require 'json'

class BlogpostParser
  PATH_TO_INDEX = "#{Rails.configuration.blog_path}/blogposts/blogposts_info.json".freeze

  def self.fetch_all
    # Add Rescue from error
    file = File.read(PATH_TO_INDEX)

    JSON.parse(file)
  end

  def self.build
    all_blogposts = []

    ['en', 'cn', 'it'].each do |locale|
      all_blogposts += BlogpostParser.build_index_with_locale(locale)
    end

#   Sort by DATE
    all_blogposts = all_blogposts.sort_by { |k| k['published_at'] }.reverse

#   Write content
    File.write(PATH_TO_INDEX, JSON.pretty_generate(all_blogposts))
  end

  def self.build_index_with_locale(locale = 'en')
    blogposts_locale_path = Dir.glob("#{ENV['BLOG_PATH']}/blogposts/#{locale}/*.md")

    # TODO: - fix the issue with this blogpost
    blogposts_path_with_errors = [ '/Users/mranieri/Documents/dev/nexmo-developer/_blog/blogposts/en/add-video-capabilities-to-zendesk-with-vonage-video-api.md']
    blogposts_locale_path -= blogposts_path_with_errors

    blogposts = blogposts_locale_path.map do |filename|
      document = File.read(filename)

      # body = Nexmo::Markdown::Renderer.new.call(document)
      frontmatter = YAML.safe_load(document, [Time])

      frontmatter.merge!(build_custom_attributes(frontmatter, filename, locale))
    end
  end

  def self.build_custom_attributes(frontmatter, filename, locale)
    frontmatter.except!('comments', 'redirect', 'canonical', 'old_categories')

    filename = File.basename(filename, '.md')
    year, month, day = frontmatter['published_at'].strftime('%y %m %d').split

    { 
      'locale'   => locale,
      'link'     => "blog/#{locale == 'en' ? '' : locale + '/'}#{year}/#{month}/#{day}/#{filename}",
      'filename' => File.basename(filename, '.md'),
      'author'   => AuthorParser.fetch_author(frontmatter['author']),
      'category' => CategoryParser.fetch_category(frontmatter['category']),
    }
  end
end
