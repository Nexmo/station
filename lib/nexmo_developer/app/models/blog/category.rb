class Blog::Category
  attr_reader   :name, :plural, :slug, :color
  attr_accessor :blogposts

  def initialize(attributes)
    # attributes.each {|k, v| self.instance_variable_set("@#{k}", v)} 
  
    @name   = attributes['name']
    @plural = attributes['plural']
    @slug   = attributes['slug']
    @color  = attributes['color']
    
    @blogposts = []
  end

  def build_n_blogposts_by_category(blogposts_json, n=0)
    bp = blogposts_json.select { |b| b['category']['slug'].downcase == @slug.downcase }

    bp = bp.first(n) if n.positive?

    @blogposts = bp.map { |b| Blog::Blogpost.new b }

    self
  end

end
  