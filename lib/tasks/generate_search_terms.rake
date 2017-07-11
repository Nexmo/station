require 'algoliasearch'

namespace :search_terms do
  desc 'Publish search terms to algolia'
  task algolia: :environment do
    Algolia.init(application_id: ENV['ALGOLIA_APPLICATION_ID'], api_key: ENV['ALGOLIA_API_KEY'])
    index = Algolia::Index.new "#{Rails.env}_nexmo_developer"
    search_articles = SearchTerms.generate

    search_articles.each do |search_article|
      Rails.logger.info search_article[:document_path]
      index.add_object(search_article)
    end
  end
end
