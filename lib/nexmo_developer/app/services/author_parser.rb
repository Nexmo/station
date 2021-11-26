require 'json'

class AuthorParser
  PATH_TO_AUTHORS = "#{Rails.configuration.blog_path}/authors/".freeze

  def self.fetch_all_authors
    authors = {}

    authors_folder_path = Dir.glob("#{PATH_TO_AUTHORS}*.json")

    authors_folder_path.each do |filename|
      document = File.read(filename)

      author_hash = YAML.safe_load(document)

      short_name = File.basename(filename, '.json')

      author_hash.merge!({ 'short_name' => short_name })

      authors[short_name.to_sym] = author_hash
    end

    authors
  end

  def self.fetch_author(name)
    author_json_path = "#{PATH_TO_AUTHORS}#{name}.json"

    return unless File.exist?(author_json_path)

    file = File.read(author_json_path)

    short_name = File.basename(author_json_path, '.json')

    JSON.parse(file).merge!({ 'short_name' => short_name })
  end

  def self.fetch_all_blogposts_from(author)
    blogposts_hash = JSON.parse(File.read(BlogpostParser::PATH_TO_INDEX))

    blogposts_hash.select { |blogpost| blogpost['author'] == author }
  end

  def self.asset_exist?(path)
    if Rails.configuration.assets.compile
      Rails.application.precompiled_assets.include? path
    else
      Rails.application.assets_manifest.assets[path].present?
    end
  end
end

# :"abdul-ajetunmobi"=>
# {"team"=>true,
#  "name"=>"Abdul Ajetunmobi",
#  "image_url"=>"https://github.com/abdulajet.png",
#  "bio"=>
# 	"Abdul is a Developer Advocate for Vonage. He has a background working in consumer products as an iOS Engineer. In his spare time, he enjoys biking, listening to music and mentoring those who are just beginning their journey in tech",
#  "website_url"=>"https://abdulajet.me",
#  "twitter"=>"abdulajet",
#  "title"=>"Vonage Developer Advocate"},
