require 'json'

class CategoryParser
  PATH_TO_CATEGORIES = "#{Rails.configuration.blog_path}/categories.json".freeze

  def self.fetch_all_categories
    JSON.parse(File.read(PATH_TO_CATEGORIES))['categories']
  end

  def self.fetch_category(slug)
    fetch_all_categories.find { |c| c['slug'] == slug.downcase }
  end

  def self.fetch_blogposts_with_category(category)
    blogposts_hash = JSON.parse(File.read(BlogpostParser::PATH_TO_INDEX))

    blogposts_hash.select { |blogpost| blogpost['category'] == category }
  end
end
