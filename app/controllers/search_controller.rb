class SearchController < ApplicationController
  def perform
    @results = client.search index: 'documents', body: { query: { fuzzy: { title: params['query'] } } }
    render 'results'
  end

  private

  def client
    @client ||= Elasticsearch::Client.new({ cluser_name: 'nexmo_development' })
  end
end
