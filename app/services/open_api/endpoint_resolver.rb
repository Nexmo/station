module OpenApi
  class EndpointResolver
    attr_accessor :specification
    attr_accessor :path
    attr_accessor :method
    attr_accessor :status

    def initialize(specification, path:, method:, status: nil)
      @specification = specification
      @path = path
      @method = method
      @status = status

      validate
    end

    def new_by_schema(schema)
      @model = parse(schema)
    end

    def model
      @model ||= parse(response_body_schema)
    end

    def response_body_schema
      endpoint.response_body_schema(status)
    end

    def json
      @json ||= model.to_json
    end

    def formatted_json
      JSON.neat_generate(model, {
        wrap: true,
        after_colon: 1,
      })
    end

    def html
      output = '<br>'
      original_status = @status

      statuses.each_with_index do |status, index|
        @status = status
        remove_instance_variable(:@model) if @model

        id = SecureRandom.hex
        visible_on_initial_load = index.zero?

        output += <<~HEREDOC
          <h4 class="collapsible #{visible_on_initial_load ? 'collapsible--active' : ''}">
            <a class="js-collapsible" data-collapsible-id="#{id}">
              <span class="label label--status--#{@status[0]}xx">#{@status}</span> HTTP response
            </a>
          </h4>
          <div id="#{id}" style="display: #{visible_on_initial_load ? 'block' : 'none'};">
            #{model_html}
          </div>
        HEREDOC
      end

      @status = original_status

      output.html_safe
    end

    def model_html
      formatter = Rouge::Formatters::HTML.new
      lexer = Rouge::Lexer.find('json')
      highlighted_response = formatter.format(lexer.lex(formatted_json))

      output = <<~HEREDOC
        <pre class="highlight json"><code>#{ highlighted_response }</code></pre>
      HEREDOC

      output.html_safe
    end

    def server
      @specification.raw['servers'].first['url']
    end

    def treat_as_object?(object)
      return true if object['type'] == 'object'
      return true if object['allOf']
      return true if object['properties']
      false
    end

    def parse(root_object)
      case root_object['type']
      when 'object' then parse_object(root_object)
      when 'array' then parse_array(root_object)
      when nil
        return nil if root_object['additionalProperties'] == false
        return nil if root_object['properties'] == {}

        if treat_as_object?(root_object)
          # Handle objects with missing type
          return parse_object(root_object.merge({ 'type' => 'object' }))
        end

        ap root_object
        raise StandardError.new("Unhandled object with missing type")
      else
        raise StandardError.new("Don't know how to parse #{root_object['type']}")
      end
    end

    def parse_object(object)
      raise StandardError.new("Not a hash") unless object.class == Hash
      raise StandardError.new("Not an object") unless object['type'] == 'object'

      if object['allOf']
        merged_object = { 'type' => 'object' }
        object['allOf'].each { |o| merged_object = merged_object.deep_merge(o) }
        return parse_object(merged_object)
      elsif object['properties']
        o = {}
        object['properties'].each do |key, value|
          o[key] = parameter_value(value)
        end

        return o
      end

      {}
    end

    def parse_array(object)
      raise StandardError.new("Not an array") unless object['type'] == 'array'

      case object['items']['type']
      when 'object'
        [parse_object(object['items'])]
      else
        if object['items']
          # Handle objects with missing type
          object['items']['type'] = 'object'
          [parse_object(object['items'])]
        else
          raise StandardError.new("parse_array: Don't know how to parse object")
        end
      end
    end

    def resolved_path
      @resolved_path = @path.dup
      path_parameters.each do |path_parameter|
        @resolved_path.gsub! "{#{path_parameter['name']}}", parameter_value(path_parameter).to_s
      end

      @resolved_path
    end

    def statuses
      endpoint.raw['responses'].keys
    end

    def status
      @status ||= statuses.first.to_s
    end

    def code_example_path
      endpoint.raw['x-code-example-path']
    end

    def jwt?
      jwt ? true : false
    end

    def jwt
      return false unless specification_has_security_schemes?
      security_references.each do |security_reference|
        securityScheme = components['securitySchemes'][security_reference]
        return securityScheme if securityScheme['bearerFormat'] == 'JWT'
      end
      false
    end

    def jwt_scopes
      specification_security_scopes = []
      endpoint_security_scopes = []

      if @specification.raw['security']
        specification_security_scopes = @specification.raw['security'].map do |security_reference|
          security_reference.values[0]
        end
      end

      if endpoint.raw['security']
        endpoint_security_scopes = endpoint.raw['security'].map do |security_reference|
          security_reference.values[0]
        end
      end

      specification_security_scopes.flatten!
      endpoint_security_scopes.flatten!

      specification_security_scopes.concat(endpoint_security_scopes).uniq
    end

    def security_references
      specification_security_references = []
      endpoint_security_references = []

      if @specification.raw['security']
        specification_security_references = @specification.raw['security'].map do |security_reference|
          security_reference.keys[0]
        end
      end

      if endpoint.raw['security']
        endpoint_security_references = endpoint.raw['security'].map do |security_reference|
          security_reference.keys[0]
        end
      end

      specification_security_references.concat(endpoint_security_references).uniq
    end

    def specification_has_security_schemes?
      return false unless components
      return false unless components['securitySchemes']
      components['securitySchemes'].any?
    end

    def components
      @specification.raw['components']
    end

    def endpoint
      @endpoint ||= @specification.endpoint(resolved_path, @method)
    end

    def id
      title.parameterize
    end

    def title
      endpoint.raw['summary'] || endpoint.raw['description']
    end

    def description
      endpoint.raw['description']
    end

    def group
      endpoint.raw['x-group']
    end

    def request_body_parameters
      return [] unless endpoint.raw['requestBody']
      parameters = self.class.normalize_properties(endpoint.raw['requestBody']['content'].values[0]['schema']['properties'])
      required_parameters = endpoint.raw['requestBody']['content'].values[0]['schema']['required']

      # Add a required key directly onto the parameter itself.
      parameters.each do |parameter|
        parameter['required'] = true if required_parameters.include? parameter['name']
      end

      parameters
    end

    def path_parameters
      @path_parameters ||= parameters.select do |parameter|
        parameter['in'] == 'path'
      end

      # For some reason for 'type: path' paramaters keys like enum are required to be in the schema.
      # This nomalizes things by entending the parameter with the schema keys giving preference to
      # the parameter keys incase of collision.
      @path_parameters.map do |parameter|
        next parameter unless parameter['schema']
        parameter['schema'].merge(parameter)
      end
    end

    def query_parameters
      @query_parameters ||= parameters.select do |parameter|
        parameter['in'] == 'query'
      end
    end

    def self.normalize_properties(properties)
      properties.map { |key, value| { 'name' => key }.merge(value) }
    end

    def self.new_by_schema(*args)
      instance = allocate
      instance.send(:new_by_schema, *args)
      instance
    end

    def callbacks
      return [] unless endpoint.raw['callbacks']

      endpoint.raw['callbacks'].map do |name, config|
        OpenApi::Callback.new(name, config)
      end
    end

    private

    def parameters
      raise StandardError.new("Path (#{@path}) does not exist") unless @specification.raw['paths'][@path]
      raise StandardError.new("Method (#{method}) does not exist on path (#{@path})") unless @specification.raw['paths'][@path][@method]
      @parameters ||= @specification.raw['paths'][@path][@method]['parameters'] || []
    end

    def parameter_value(parameter)
      return parameter['example'] if parameter['example']
      case (parameter['schema'] ? parameter['schema']['type'] : parameter['type'])
      when 'integer' then return 1
      when 'number' then return 1.0
      when 'string' then return 'abc123'
      when 'boolean' then return false
      when 'object' then return parse_object(parameter)
      when 'array' then return parse_array(parameter)
      else
        raise StandardError.new("Can not resolve parameter type of #{parameter['type']}")
      end
    end

    def validate
      raise raise StandardError.new("Specification missing") unless @specification
      raise raise StandardError.new("Path missing") unless @path
      raise raise StandardError.new("Method missing") unless @method
      raise raise StandardError.new("Status missing") unless status
    end
  end
end
