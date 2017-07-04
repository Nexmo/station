require 'algoliasearch'

namespace :search_terms do
  desc 'Drop and regenerate the search terms'
  task regenerate: :environment do
    Rake::Task['search_terms:drop'].invoke
    Rake::Task['search_terms:generate'].invoke
  end

  desc 'Publish search terms to algolia'
  task algolia: :environment do
    Algolia.init(application_id: ENV['ALGOLIA_APPLICATION_ID'], api_key: ENV['ALGOLIA_API_KEY'])
    index = Algolia::Index.new "#{Rails.env}_nexmo_developer"
    search_articles = SearchTerms.generate
    index.add_objects(search_articles)
  end
end
