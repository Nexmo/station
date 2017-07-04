class SearchController < ApplicationController
  include ApplicationHelper

  before_action :check_search_is_enabled
  before_action :set_results

  def results; end

  def quicksearch
    render layout: false
  end

  private

  def client
    @client ||= Rails.configuration.elastic_search_client({ cluser_name: "nexmo_#{Rails.env}" })
  end

  def set_results
    return unless params['query']

    algolia_search_parameters = ALGOLIA_CONFIG.map do |index, config|
      algolia_index_search_parameters = {
        index_name: index,
        query: params['query'],
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

    results = Algolia.multiple_queries(algolia_search_parameters)

    @results = JSON.parse(results.to_json, object_class: OpenStruct).results
    @results_total = @results.sum(&:nbHits)
  end

  def check_search_is_enabled
    redirect_to root_path unless search_enabled?
  end
end
