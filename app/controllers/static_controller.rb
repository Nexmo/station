class StaticController < ApplicationController
  def landing
    render layout: 'landing'
  end

  def documentation
    @navigation = :documentation
    render layout: 'documentation'
  end

  def tools
    @navigation = :tools
    render layout: 'page'
  end

  def community
    @navigation = :community
    @upcoming_events = Event.upcoming
    @sessions = Session.all
    render layout: 'page'
  end

  def styleguide
    # Read document
    document = File.read("#{Rails.root}/app/views/static/styleguide.md")

    # Parse frontmatter
    @frontmatter = YAML.safe_load(document)

    @title = @frontmatter['title']

    @side_navigation = 'api/styleguide'

    @content = MarkdownPipeline.new.call(document)

    render layout: 'static'
  end

  def write_the_docs
    # Read document
    document = File.read("#{Rails.root}/app/views/static/write-the-docs.md")

    # Parse frontmatter
    @frontmatter = YAML.safe_load(document)

    @title = @frontmatter['title']

    @side_navigation = 'api/write-the-docs'

    @content = MarkdownPipeline.new.call(document)

    render layout: 'static'
  end

  def robots
    render 'robots.txt'
  end
end
