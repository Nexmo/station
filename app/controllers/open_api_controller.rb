class OpenApiController < ApplicationController
  before_action :set_definition

  def show
    @definition_path = "_open_api/#{@definition}.json"
    @definition = OpenApiParser::Specification.resolve(@definition_path)
    render layout: 'page-full'
  end

  private

  def set_definition
    @definition = params[:definition]
  end
end
