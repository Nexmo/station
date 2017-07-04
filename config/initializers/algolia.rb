begin
  # First check if algolia config is set as an env variable. If so, use it.
  # Otherwise try to load algolia.yml from the config directory.
  if ENV['ALGOLIA_CONFIG']
    ALGOLIA_CONFIG = YAML.safe_load(ENV['ALGOLIA_CONFIG'])
  else
    ALGOLIA_CONFIG = YAML.load_file("#{Rails.root}/config/algolia.yml")
  end
rescue Exception => e
  # No config is found, therefor search will simply be disabled.
end

if ENV['ALGOLIA_APPLICATION_ID'] && ENV['ALGOLIA_API_KEY']
  Algolia.init(application_id: ENV['ALGOLIA_APPLICATION_ID'], api_key: ENV['ALGOLIA_API_KEY'])
end
