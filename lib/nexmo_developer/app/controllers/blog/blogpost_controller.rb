class Blog::BlogpostController < Blog::MainController
  def index
    @data = BlogpostParser.fetch_all
    @authors = AuthorParser.fetch_all_authors
    @categories = CategoryParser.fetch_all_categories
  end

  def show
    @author = AuthorParser.fetch_author(params[:author])
    @content = Blogpost.with_path(params[:blog_path], 'en')
  end

  # Rake Task??
  # def create_json_data_file
  #   JsonParser.write_all()
  # end
end
