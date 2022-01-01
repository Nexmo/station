class Blog::BlogpostController < Blog::MainController
  LATEST_FOR_PREVIEW    = 2
  BLOGPOSTS_FOR_PREVIEW = 6

  def index
#   Fetch data as Json
#   TODO: Cache data
    data = BlogpostParser.fetch_all 
    @authors = AuthorParser.fetch_all_authors
    categories = CategoryParser.fetch_all_categories

 #  Build Blogposts by category
    @categories_with_blogposts = categories.map do |category| 
      Blog::Category.new(category).build_n_blogposts_by_category(data, BLOGPOSTS_FOR_PREVIEW)
    end

#   Build latest Blogposts
    @latest_blogposts = data.first(LATEST_FOR_PREVIEW)
                            .map { |attributes| Blog::Blogpost.new(attributes) }
  end

  def show
    @blogpost = Blog::Blogpost.build_blogpost_from_path(params[:blog_path], 'en')
  end
end
