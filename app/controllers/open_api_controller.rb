class OpenApiController < ApplicationController
  before_action :set_specification

  def show
    if File.file? "_open_api/#{@specification_name}.json"
      @specification_path = "_open_api/#{@specification_name}.json"
    else
      @specification_path = "_open_api/#{@specification_name}.yml"
    end

    @specification = OpenApiParser::Specification.resolve(@specification_path)
    set_groups

    render layout: 'page-full'
  end

  private

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
