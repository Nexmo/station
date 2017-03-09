class StaticController < ApplicationController
  def landing
    @navigation = :documentation
    render layout: 'landing'
  end

  def tools
    @navigation = :tools
  end

  def community
    @navigation = :community
    @upcoming_events = Event.upcoming
  end

  def styleguide
    # Read document
    document = File.read("#{Rails.root}/app/views/static/styleguide.md")

    # Parse frontmatter
    @frontmatter = YAML.load(document)

    @title = @frontmatter["title"]

    @side_navigation = "api/styleguide"

    @content = MarkdownPipeline.new.call(document)

    render layout: 'documentation'
  end

  def copyguide
    # Read document
    document = File.read("#{Rails.root}/app/views/static/copyguide.md")

    # Parse frontmatter
    @frontmatter = YAML.load(document)

    @title = @frontmatter["title"]

    @side_navigation = "api/copyguide"

    @content = MarkdownPipeline.new.call(document)

    render layout: 'documentation'
  end
end
