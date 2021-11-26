class Blogpost
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
