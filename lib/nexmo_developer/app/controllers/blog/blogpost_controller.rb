class Blog::BlogpostController < Blog::MainController
  def index
##### RAW DATA
    # All blogposts as Json [{title: .., descr: ..}, {...}, ...]
    @data = BlogpostParser.fetch_all

##### CATEGORIES
    # All categories as Json [{name: .., slug: ..}, {...}, ...]
    @categories = CategoryParser.fetch_all_categories
    
    data = @data.dup
    @categories.map! do |c| 
      category = Blog::Category.new(c)
      
      # Assign 6 blogposts to each category to display
      category.return_n_blogposts_with_category_from(data, 6)
      
      category
    end
    
##### AUTHORS
    @authors = AuthorParser.fetch_all_authors


##### BLOGPOSTS
    # Latest 2 Blog::Blogpost Instances
    @latest_blogposts = @data.shift(2)
                             .map  { |b| Blog::Blogpost.new b }
                             .each { |b| b.author = Blog::Author.new(@authors[b.author.to_sym]) }

  end

  def show
    @author = AuthorParser.fetch_author(params[:author])
    @content = Blog::Blogpost.with_path(params[:blog_path], 'en')
  end

  # Rake Task??
  # def create_json_data_file
  #   JsonParser.write_all()
  # end
end
