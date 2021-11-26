class Blog::TagsController < Blog::MainController
  def show
    @authors   = AuthorParser.fetch_all_authors
    @blogposts = TagParser.fetch_blogposts_with_tag(params[:slug])
  end
end
