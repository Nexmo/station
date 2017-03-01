SEARCH_ARTICLES = SearchTerms.generate

client = Elasticsearch::Client.new({ cluser_name: 'nexmo_development' })

SEARCH_ARTICLES.each do |search_article|
  client.index index: 'documents', type: 'document', body: search_article
end

# Search all documents
# client.search index: 'documents', body: { query: { fuzzy: { title: 'sms' } } }

# Delete all documents
# client.delete_by_query index: 'documents', type: 'document', body: { query: { match_all: {} } }
