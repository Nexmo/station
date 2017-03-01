class SearchController < ApplicationController
  def perform
    if params['query']
      @results = client.search index: 'documents', body: { query: { fuzzy: { title: params['query'] } } }
    end

    render 'results'
  end

  private

  def client
    @client ||= Rails.configuration.elastic_search_client({ cluser_name: 'nexmo_development' })
  end
end
