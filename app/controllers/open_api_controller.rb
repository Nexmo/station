class OpenApiController < ApplicationController
  before_action :set_definition
  before_action :set_navigation

  def show
    if File.file? "_open_api/definitions/#{@definition_name}.json"
      @definition_path = "_open_api/definitions/#{@definition_name}.json"
      @definition_format = 'json'
    elsif File.file? "_open_api/definitions/#{@definition_name}.yml"
      @definition_path = "_open_api/definitions/#{@definition_name}.yml"
      @definition_format = 'yml'
    elsif NexmoApiSpecification::Definition.exists?(@definition_name)
      @definition_path = NexmoApiSpecification::Definition.path(@definition_name)
      @definition_format = 'yml'
    else
      raise 'Definition can not be found'
    end

    if File.file? "_open_api/initialization/#{@definition_name}.md"
      definition_initialization = File.read("_open_api/initialization/#{@definition_name}.md")
      @definition_initialization_content = MarkdownPipeline.new.call(File.read("_open_api/initialization/#{@definition_name}.md"))
      @definition_initialization_config = YAML.safe_load(definition_initialization)
    end

    if File.file? "_open_api/errors/#{@definition_name}.md"
      definition_errors = File.read("_open_api/errors/#{@definition_name}.md")
      @definition_errors_content = MarkdownPipeline.new.call(File.read("_open_api/errors/#{@definition_name}.md"))
    end

    respond_to do |format|
      format.any(:json, :yaml) { send_file(@definition_path) }
      format.html do
        @definition = OasParser::Definition.resolve(@definition_path)
        # set_groups
        render layout: 'page-full'
      end
    end
  end

  private

  def set_navigation
    @navigation = :api
  end

  def set_definition
    @definition_name = params[:definition]
  end

  def set_groups
    @groups = {}

    @definition.raw['paths'].each do |path, methods|
      methods.each do |method, endpoint|
        group = endpoint['x-group']

        if @groups[group].nil?
          @groups[group] = @definition.raw['x-groups'] ? @definition.raw['x-groups'][endpoint['x-group']] : {}
          @groups[group][:resources] = []
        end

        @groups[group][:resources] << {
          path: path,
          method: method,
        }
      end
    end

    @groups = @groups.values.sort_by do |group|
      group['order'] || 999
    end
  end
end
