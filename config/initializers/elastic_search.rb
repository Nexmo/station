Rails.configuration.elastic_search_client = Elasticsearch::Client.new(
  url: ENV['BONSAI_URL'] || 'http://localhost:9200',
  log: true
)
