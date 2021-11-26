require 'json'

class CategoryParser

	PATH_TO_CATEGORIES = "#{Rails.configuration.blog_path}/categories.json"
	
	# def self.fetch_all_categories
  #   JSON.parse(File.read(PATH_TO_CATEGORIES))
	# end

  def self.fetch_blogposts_with_category(category)
    blogposts_hash = JSON.parse(File.read(BlogpostParser::PATH_TO_INDEX))
    
    blogposts_hash.select { |blogpost| blogpost['category'] == category }
  end

end
