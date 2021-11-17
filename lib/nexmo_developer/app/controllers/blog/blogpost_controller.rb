class Blog::BlogpostController < Blog::MainController

  def show
    @content = Blogpost.withPath(params[:blog_path], 'en') 
  end


end
