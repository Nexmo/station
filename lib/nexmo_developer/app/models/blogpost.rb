class Blogpost

  def self.withPath(path, locale) 
    # path is: 'santa-is-here' for URL: '/blog/2021/12/25/santa-is-here'
    # make sure the path is valid
    if path.nil? || path.empty?
      return nil
    end
    # find the blogpost accourding to the path
    # pp Rails.configuration
    # return ""
    path = "#{Rails.configuration.blog_path}/blogposts/#{locale}/#{path}.md"
    unless File.exist?(path)
      return "<h1>No such blog</h1><p>#{path}</p>" # todo - default not found page
    end

    return path
    # content = File.read(path)
    # content = Nexmo::Markdown::Renderer.new({}).call(content)
    # return content
  end

end