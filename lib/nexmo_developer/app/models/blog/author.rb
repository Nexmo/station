
class Blog::Author
  attr_reader :name, :title, :bio, :short_name, :email, :image_url,
              :author, :alumni, :team, :hidden, :spotlight, :noteworthy,
              :website_url, :twitter, :linkedin_url, :github_url, :youtube_url, :facebook_url

  def initialize(attributes)
    attributes.each {|k, v| self.instance_variable_set("@#{k}", v)} 

    # @name       = attributes['name']
    # @title      = attributes['title']
    # @bio        = attributes['bio']
    # @short_name = attributes['short_name']
    # @email      = attributes['email']
    # @image_url  = attributes['image_url']
    
    # @author     = attributes['author'] || ''
    # @alumni     = attributes['alumni'] || false
    # @team       = attributes['team'] || false
    # @hidden     = attributes['hidden'] || false
    # @spotlight  = attributes['spotlight'] || false
    # @noteworthy = attributes['noteworthy'] || ''
    
    # @website_url  = attributes['website_url'] || ''
    # @twitter      = attributes['twitter'] || ''
    # @linkedin_url = attributes['linkedin_url'] || ''
    # @github_url   = attributes['github_url'] || ''
    # @youtube_url  = attributes['youtube_url'] || ''
    # @facebook_url = attributes['facebook_url'] || ''
  end

end
  