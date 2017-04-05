class SearchController < ApplicationController
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
    #
    query = {
      query: {
        match: {
          title: {
            query: params['query'],
            minimum_should_match: '80%',
          },
        },
      },
    }

    @results = client.search index: 'documents', body: query
  end
end
