require 'pry'
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

  def return_n_blogposts_with_category_from(blogposts_json, n=0)
    
    bp = blogposts_json.select { |b| 
      
      # binding.pry if @slug == 'release'
      
      b['category'].downcase == @slug.downcase 
    }


    bp = bp.first(n) if n.positive?

    @blogposts = bp.map { |b| Blog::Blogpost.new b }
                              #  .compact

  end

end
  