class Blog::Category
  attr_reader :name, :plural, :slug, :color
  attr_accessor :blogposts

  def initialize(attributes)
    # attributes.each {|k, v| self.instance_variable_set("@#{k}", v)} 
  
    @name   = attributes['name']
    @plural = attributes['plural']
    @slug   = attributes['slug']
    @color  = attributes['color']
    
    @blogposts = []
  end

  def return_n_blogposts_with_category_from(blogposts, n=0)
    blogposts.select! { |b| b['category'] == @slug }

    blogposts = blogposts.first(n) if n.positive?
raise
    @blogposts = blogposts.map { |b| Blog::Blogpost.new b }
                          .each { |b| b.author = Blog::Author.new(@authors[b.author.to_sym]) }
                          .compact
  end

end
  