class SearchController < ApplicationController
  include ApplicationHelper

  before_action :validate_query_is_present
  before_action :check_search_is_enabled

  def results
    respond_to do |format|
      format.html do
        @results = JSON.parse(get_results.to_json, object_class: OpenStruct).results
        @results_total = @results.sum(&:nbHits)
      end
      format.json do
        @hits_per_page = 4
        render json: get_results['results']
      end
    end
  end

  def quicksearch
    render layout: false
  end

  private

  def validate_query_is_present
    redirect_to root_path unless params['query']
  end

  def get_results
    return unless params['query']

    algolia_search_parameters = ALGOLIA_CONFIG.map do |index, config|
      algolia_index_search_parameters = {
        index_name: index,
        query: params['query'],
        hitsPerPage: @hits_per_page || 25,
        attributesToSnippet: ['body', 'body_safe'],
      }

      if config && config['filters']
        filters = config['filters'].map do |facet, values|
          values.map do |value|
            "#{facet}: #{value}"
          end
        end

        filters = filters.flatten.join(' AND NOT ').prepend('NOT ')
        algolia_index_search_parameters[:filters] = filters
      end

      algolia_index_search_parameters
    end

    Algolia.multiple_queries(algolia_search_parameters)
  end

  def check_search_is_enabled
    redirect_to root_path unless search_enabled?
  end
end
