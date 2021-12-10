class Blog::AuthorsController < Blog::MainController
  def show
    # @author    = AuthorParser.fetch_author(params[:name])
    @authors   = { params[:name].to_sym => AuthorParser.fetch_author(params[:name]) }
    @blogposts = AuthorParser.fetch_all_blogposts_from(params[:name])
  end
end
