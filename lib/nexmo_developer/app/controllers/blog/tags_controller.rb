class Blog::TagsController < Blog::MainController
  def show
    @tag = params['slug']

    blogposts = TagParser.fetch_blogposts_with_tag(params[:slug])
    @blogposts = blogposts.map { |attributes| Blog::Blogpost.new attributes } 
  end
end

