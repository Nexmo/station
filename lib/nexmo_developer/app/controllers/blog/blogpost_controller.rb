class Blog::BlogpostController < Blog::MainController
  LATEST_FOR_PREVIEW    = 2
  BLOGPOSTS_FOR_PREVIEW = 6
  RELATED_FOR_PREVIEW   = 3

  def index
    #   Fetch data as Json
    data = BlogpostParser.fetch_all_published

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

    @blogButtonPath = "https://dashboard.nexmo.com/sign-up?icid=tryitfree_adpblog-#{params[:blog_path]}_nexmodashbdfreetrialsignup_banner"
    redirect_to blog_path unless @blogpost.published

    data = BlogpostParser.fetch_all_published

    @related_blogposts = data.select { |b| b['category']['slug'] == @blogpost.category.slug && b['title'] != @blogpost.title }
                             .first(RELATED_FOR_PREVIEW)
                             .sort_by { |b| b['updated_at'] }.reverse
                             .map { |attributes| Blog::Blogpost.new attributes }
  end
end
