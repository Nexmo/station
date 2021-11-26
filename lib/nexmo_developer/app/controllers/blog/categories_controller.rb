class Blog::CategoriesController < Blog::MainController

  def show
    @authors   = AuthorParser.fetch_all_authors
    @blogposts = CategoryParser.fetch_blogposts_with_category(params[:slug])
  end

end
