class StaticController < ApplicationController
  def landing
    render layout: 'landing'
  end

  def documentation
    @navigation = :documentation

    # Read document
    document = File.read("#{Rails.root}/app/views/static/documentation.md")

    # Parse frontmatter
    @frontmatter = YAML.safe_load(document)

    @document_title = @frontmatter['title']

    @content = MarkdownPipeline.new.call(document)

    render layout: 'documentation'
  end

  def tools
    @navigation = :tools
    @document_title = "SDKs & Tools"
    render layout: 'page'
  end

  def community
    @navigation = :community
    @document_title = "Community"
    @upcoming_events = Event.upcoming
    @sessions = Session.all
    render layout: 'page'
  end

  def contribute
    # Read document
    document = File.read("#{Rails.root}/app/views/static/contribute.md")

    # Parse frontmatter
    @frontmatter = YAML.safe_load(document)

    @document_title = @frontmatter['title']

    @content = MarkdownPipeline.new.call(document)

    render layout: 'static'
  end

  def styleguide
    # Read document
    document = File.read("#{Rails.root}/app/views/static/styleguide.md")

    # Parse frontmatter
    @frontmatter = YAML.safe_load(document)

    @document_title = @frontmatter['title']

    @side_navigation = 'api/styleguide'

    @content = MarkdownPipeline.new.call(document)

    render layout: 'static'
  end

  def write_the_docs
    # Read document
    document = File.read("#{Rails.root}/app/views/static/write-the-docs.md")

    # Parse frontmatter
    @frontmatter = YAML.safe_load(document)

    @document_title = @frontmatter['title']

    @side_navigation = 'api/write-the-docs'

    @content = MarkdownPipeline.new.call(document)

    render layout: 'static'
  end

  def robots
    render 'robots.txt'
  end
end
