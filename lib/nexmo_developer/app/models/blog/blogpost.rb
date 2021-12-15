class Blog::Blogpost

  attr_accessor :title, :description, :thumbnail, :author, :published, :published_at,
                :updated_at, :category, :tags, :link, :locale, :slug

  def initialize(attributes)
    attributes.each {|k, v| self.instance_variable_set("@#{k}", v)} 

    # @title        = attributes['title']
    # @description  = attributes['description']
    # @thumbnail    = attributes['thumbnail']
    # @author       = attributes['author']
    # @published    = attributes['published']
    # @published_at = attributes['published_at']
    # @updated_at   = attributes['updated_at']
    # @category     = attributes['category']
    # @tags         = attributes['tags']
    # @link         = attributes['link']
    # @locale       = attributes['locale']
    # @slug         = attributes['slug']
  end

  def self.with_path(path, locale)
    return if path.blank?

    path = "#{Rails.configuration.blog_path}/blogposts/#{locale}/#{path}.md"

    unless File.exist?(path)
      return "<h1>No such blog</h1><p>#{path}</p>" # TODO: - default not found page
    end

    document = File.read(path)
    Nexmo::Markdown::Renderer.new({}).call(document)
  end
end
