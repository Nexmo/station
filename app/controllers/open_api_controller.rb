class OpenApiController < ApplicationController
  before_action :set_specification
  before_action :set_navigation

  def show
    if File.file? "_open_api/definitions/#{@specification_name}.json"
      @specification_path = "_open_api/definitions/#{@specification_name}.json"
      @specification_format = 'json'
    elsif File.file? "_open_api/definitions/#{@specification_name}.yml"
      @specification_path = "_open_api/definitions/#{@specification_name}.yml"
      @specification_format = 'yml'
    elsif NexmoApiSpecification::Definition.exists?(@specification_name)
      @specification_path = NexmoApiSpecification::Definition.path(@specification_name)
      @specification_format = 'yml'
    else
      raise 'Definition can not be found'
    end

    specification_initialization = File.read("_open_api/initialization/#{@specification_name}.md")
    @specification_initialization_content = MarkdownPipeline.new.call(File.read("_open_api/initialization/#{@specification_name}.md"))
    @specification_initialization_config = YAML.safe_load(specification_initialization)

    if File.file? "_open_api/errors/#{@specification_name}.md"
      specification_errors = File.read("_open_api/errors/#{@specification_name}.md")
      @specification_errors_content = MarkdownPipeline.new.call(File.read("_open_api/errors/#{@specification_name}.md"))
    end

    respond_to do |format|
      format.any(:json, :yaml) { send_file(@specification_path) }
      format.html do
        @specification = OpenApiParser::Specification.resolve(@specification_path)
        set_groups

        render layout: 'page-full'
      end
    end
  end

  private

  def set_navigation
    @navigation = :api
  end

  def set_specification
    @specification_name = params[:specification]
  end

  def set_groups
    @groups = {}

    @specification.raw['paths'].each do |path, methods|
      methods.each do |method, endpoint|
        group = endpoint['x-group']

        if @groups[group].nil?
          @groups[group] = @specification.raw['x-groups'] ? @specification.raw['x-groups'][endpoint['x-group']] : {}
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
