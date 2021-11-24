class Blogpost

  def self.withPath(path, locale) 
    return if path.nil? || path.empty?

    path = "#{Rails.configuration.blog_path}/blogposts/#{locale}/#{path}.md"
    
    unless File.exist?(path)
      return "<h1>No such blog</h1><p>#{path}</p>" # todo - default not found page
    end
    
    document = File.read(path)
    content = Nexmo::Markdown::Renderer.new({}).call(document)
    return content
  end

end