namespace :search_terms do
  desc 'Drop and regenerate the search terms'
  task :regenerate => :environment do
    Rake::Task['search_terms:drop'].invoke
    Rake::Task['search_terms:generate'].invoke
  end

  desc 'Generate the search terms'
  task :generate => :environment do
    client = Rails.configuration.elastic_search_client({ cluser_name: "nexmo_#{Rails.env}" })

    unless client.indices.exists index: 'documents'
      client.indices.create index: 'documents'
    end

    search_articles = SearchTerms.generate
    search_articles.each do |search_article|
      client.index index: 'documents', type: 'document', body: search_article
    end
  end

  desc 'Drop the search terms'
  task :drop => :environment do
    client = Rails.configuration.elastic_search_client({ cluser_name: "nexmo_#{Rails.env}" })
    client.delete_by_query index: 'documents', type: 'document', body: { query: { match_all: {} } }
  end
end
