class StaticController < ApplicationController
  def landing
    @navigation = :documentation
    render layout: 'landing'
  end

  def tools
    @navigation = :tools
    render layout: 'page'
  end

  def community
    @navigation = :community
    @upcoming_events = Event.upcoming
    render layout: 'page'
  end

  def styleguide
    # Read document
    document = File.read("#{Rails.root}/app/views/static/styleguide.md")

    # Parse frontmatter
    @frontmatter = YAML.load(document)

    @title = @frontmatter['title']

    @side_navigation = 'api/styleguide'

    @content = MarkdownPipeline.new.call(document)

    render layout: 'static'
  end

  def write_the_docs
    # Read document
    document = File.read("#{Rails.root}/app/views/static/write-the-docs.md")

    # Parse frontmatter
    @frontmatter = YAML.load(document)

    @title = @frontmatter['title']

    @side_navigation = 'api/write-the-docs'

    @content = MarkdownPipeline.new.call(document)

    render layout: 'static'
  end
end
