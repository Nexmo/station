require 'json'

class CategoryParser

	PATH_TO_CATEGORIES = "#{Rails.configuration.blog_path}/categories.json"
	
	def self.fetch_all_categories
    JSON.parse(File.read(PATH_TO_CATEGORIES))
	end

end
