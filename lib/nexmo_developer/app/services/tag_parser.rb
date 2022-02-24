require 'json'

class TagParser
  # PATH_TO_CATEGORIES = "#{Rails.configuration.blog_path}/categories.json"

  # def self.fetch_all_categories
  #   JSON.parse(File.read(PATH_TO_CATEGORIES))
  # end

  TAGS_WITH_ICON = [
    'dispatch-api',
    'messages-api',
    'messages-api-sandbox',
    'number-insight-api',
    'number-api',
    'reports-api',
    'account-api',
    'pricing-api',
    'external-accounts-api',
    'redact-api',
    'audit-api',
    'verify-api',
    'media-api',
    'voice-api',
    'conversation-api',
    'video-api',
    'sms-api',
    'station',
    'spotlight',
    'voyagers',
  ].freeze

  def self.fetch_blogposts_with_tag(tag)
    blogposts_hash = JSON.parse(File.read(BlogpostParser::PATH_TO_INDEX))

    blogposts_hash.select { |b| b['tags'].include?(tag) && b['published'] && !b['outdated'] }
  end
end
