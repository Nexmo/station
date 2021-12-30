class Blog::Blogpost

  attr_accessor :title, :description, :thumbnail, :author, :published, :published_at,
                :updated_at, :category, :tags, :link, :locale, :slug, :spotlight, :filename

  def initialize(attributes)
    # attributes.each {|k, v| self.instance_variable_set("@#{k}", v)} 

    @title        = attributes['title']
    @description  = attributes['description']
    @thumbnail    = attributes['thumbnail']
    @published    = attributes['published']
    @published_at = attributes['published_at']
    @updated_at   = attributes['updated_at']
    @tags         = attributes['tags']
    @link         = attributes['link']
    @locale       = attributes['locale']
    @outdated     = attributes['outdated']
    @spotlight    = attributes['spotlight']
    @filename     = attributes['filename']

    @author       = Blog::Author.new(attributes['author'])
    @category     = Blog::Category.new(attributes['category'])
    
    @replacement_url  = attributes['replacement_url']
  end

  def self.with_path(path, locale)
    return if path.blank?

    path = "#{Rails.configuration.blog_path}/blogposts/#{locale}/#{path}.md"

    # TODO: - default not found page 
    return "<h1>No such blog</h1><p>#{path}</p>" unless File.exist?(path)

    document = File.read(path)
    Nexmo::Markdown::Renderer.new({}).call(document)
  end
end
