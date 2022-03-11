class Blog::Blogpost
  attr_accessor :title, :description, :thumbnail, :author, :published, :published_at,
                :updated_at, :category, :tags, :link, :locale, :slug, :spotlight,
                :filename, :content, :header_img_url

  CLOUDFRONT_BLOG_URL     = 'https://d226lax1qjow5r.cloudfront.net/blog/'.freeze
  DEFAULT_VONAGE_LOGO_URL = 'https://s3.eu-west-1.amazonaws.com/developer.vonage.com/vonage-logo-images/vonage-wide-logo.png'.freeze

  def initialize(attributes)
    @title        = attributes['title']
    @description  = attributes['description']
    @thumbnail    = attributes['thumbnail']    || ''
    @published    = attributes['published']    || false
    @published_at = attributes['published_at']
    @updated_at   = attributes['updated_at']
    @tags         = attributes['tags']         || []
    @link         = attributes['link']         || ''
    @filename     = attributes['filename']
    @locale       = attributes['locale']       || 'en'
    @outdated     = attributes['outdated']     || false
    @spotlight    = attributes['spotlight']    || false

    @author       = Blog::Author.new(attributes['author'] || {})  # TODO: DEFAULT AUTHOR
    @category     = Blog::Category.new(attributes['category'])

    @content        = ''
    @header_img_url = build_bucket_img_url_from_thumbnail

    @replacement_url  = attributes['replacement_url']
  end

  def self.build_blogpost_from_path(path, locale)
    return if path.blank?

    path = "#{Rails.configuration.blog_path}/blogposts/#{locale}/#{path}.md"

    default_not_found_page(path) unless File.exist?(path)

    document = File.read(path).gsub('/content/blog/') do |match| # gsub Netlify img urls
      "#{Blog::Blogpost::CLOUDFRONT_BLOG_URL}blogposts/#{match.gsub('/content/blog/', '')}"
    end

    blogpost = new(BlogpostParser.build_show_with_locale(path, locale))
    blogpost.content = Nexmo::Markdown::Renderer.new({}).call(document)

    blogpost
  end

  def build_bucket_img_url_from_thumbnail
    require 'net/http'
    require 'addressable'

    @thumbnail = @thumbnail.gsub('/content/blog/') do |match| # gsub Netlify img urls
      "#{Blog::Blogpost::CLOUDFRONT_BLOG_URL}blogposts/#{match.gsub('/content/blog/', '')}"
    end

    url = Addressable::URI.parse(@thumbnail)

    Net::HTTP.start(url.host, url.port, use_ssl: true) do |http|
      if http.head(url.request_uri)['Content-Type'].start_with? 'image'
        @thumbnail
      else
        DEFAULT_VONAGE_LOGO_URL
      end
    end
  end

  def self.default_not_found_page(path)
    # TODO: - default not found page
    #  get '*unmatched_route', to: 'application#not_found'
    #  is already taking care of any wrong route
    "<h1>No such blog</h1><p>#{path}</p>"
  end
end
