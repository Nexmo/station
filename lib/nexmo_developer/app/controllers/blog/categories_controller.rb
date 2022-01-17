class Blog::CategoriesController < Blog::MainController
  def show
    data = BlogpostParser.fetch_all
    attributes = CategoryParser.fetch_category(params[:slug])

    @category_with_all_blogposts = Blog::Category.new(attributes).build_n_blogposts_by_category(data)
  end
end
