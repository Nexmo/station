class Blog::AuthorsController < Blog::MainController
  def show
    data       = BlogpostParser.fetch_all.select { |b| b['published'] && !b['outdated'] }
    attributes = AuthorParser.fetch_author(params[:name]) || {}

    @author    = Blog::Author.new(attributes).build_all_blogposts_from_author(data)
  end
end
