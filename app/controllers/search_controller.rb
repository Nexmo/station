class SearchController < ApplicationController
  include ApplicationHelper

  rescue_from RestClient::InternalServerError, with: :search_error
  rescue_from RestClient::NotFound, with: :search_error

  before_action :validate_query_is_present
  before_action :check_search_is_enabled

  def results
    @results = JSON.parse(get_results, object_class: OpenStruct).results
    @results_total = @results.sum(&:nbHits)
  end

  private

  def validate_query_is_present
    redirect_to root_path unless params['query']
  end

  def get_results
    return unless params['query']
    RestClient.get ENV['SEARCH_URL'], {
      params: { query: params['query'] },
    }
  end

  def search_error
    render 'search_error'
  end

  def check_search_is_enabled
    redirect_to root_path unless search_enabled?
  end
end
