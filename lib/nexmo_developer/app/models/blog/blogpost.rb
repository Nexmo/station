class Blog::Blogpost
  attr_accessor :title, :description, :thumbnail, :author, :published, :published_at,
                :updated_at, :category, :tags, :link, :locale, :slug, :spotlight,
                :filename, :content, :header_img_url

  CLOUDFRONT_BLOG_URL     = 'https://d226lax1qjow5r.cloudfront.net/blog/'.freeze
  DEFAULT_VONAGE_LOGO_URL = 'https://s3.eu-west-1.amazonaws.com/developer.vonage.com/vonage-logo-images/vonage_logo_primary_white_1200x600.png'.freeze

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

    document = clean_document_from_netlify(path)

    blogpost = new(BlogpostParser.build_show_with_locale(path, locale))
    blogpost.content = Nexmo::Markdown::Renderer.new({}).call(document)

    blogpost
  end

  def build_bucket_img_url_from_thumbnail
    require 'net/http'
    require 'addressable'

    return DEFAULT_VONAGE_LOGO_URL if @thumbnail.empty?

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
    "<h1>No such blog</h1><p>#{path}</p>"
  end

  def self.clean_document_from_netlify(path)
    # Netlify - Imgage urls to S3 Bucket
    document = File.read(path).gsub('/content/blog/') { |match| "#{Blog::Blogpost::CLOUDFRONT_BLOG_URL}blogposts/#{match.gsub('/content/blog/', '')}" }

    # Netlify - SIGN UP Banner
    document = document.gsub(%r{<sign-up></sign-up>}, "#{banner_text}#{build_image_tag}")

    # Netlify - SIGN UP Banner + Number
    document = document.gsub(%r{<sign-up number></sign-up>}) do |_match|
      "#{banner_text}<p>This tutorial also uses a virtual phone number. To purchase one, go to <em>Numbers > Buy Numbers</em> and search for one that meets your needs.</p>#{build_image_tag}"
    end

    # Netlify - Embedded YOUTUBE Video
    document.gsub(%r{<youtube id="(\w+)"></youtube>}) do |match|
      youtube_id = match[/(?<=").*(?=")/]
      "<center class='video'><br><iframe width='448' height='252' src='https://www.youtube-nocookie.com/embed/#{youtube_id}' frameborder='0' allow='accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture' allowfullscreen></iframe><br><br></center>"
    end
  end

  # NETLIFY Helpers
  def self.s3_banner_image
    'https://s3.eu-west-1.amazonaws.com/developer.vonage.com/blog/signup_banner/sign_up_banner.png'
  end

  def self.build_image_tag
    "<p></p><figure><img src='#{s3_banner_image}' alt='Screenshot of new Meetings API session in progress'><figcaption class='Vlt-center'><em>Start developing in minutes with free credits on us. No credit card required!</em></figcaption></figure><p></p>"
  end

  def self.banner_text
    "<h3 class='Vlt-title--icon'>Vonage API Account</h3><p>To complete this tutorial, you will need a <a href='https://dashboard.nexmo.com/sign-up' target='_blank'>Vonage API account</a>. If you don’t have one already, you can sign up today and start building with free credit. Once you have an account, you can find your API Key and API Secret at the top of the <a href='https://dashboard.nexmo.com/sign-up' target='_blank'>Vonage API Dashboard</a>.</p>"
  end
end
