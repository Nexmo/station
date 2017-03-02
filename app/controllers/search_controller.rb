class SearchController < ApplicationController
  before_action :set_results

  def results
  end

  def quicksearch
    render layout: false
  end

  private

  def client
    @client ||= Rails.configuration.elastic_search_client({ cluser_name: 'nexmo_development' })
  end

  def set_results
    if params['query']
      @results = client.search index: 'documents', body: { query: { fuzzy: { title: params['query'] } } }
    end
  end
end
