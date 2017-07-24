class StaticController < ApplicationController
  def landing
    render layout: 'landing'
  end

  def documentation
    @navigation = :documentation

    @document_path = "/app/views/static/documentation.md"

    # Read document
    document = File.read("#{Rails.root}/#{@document_path}")

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
    @past_events_count = Event.past.count
    @sessions = Session.all
    render layout: 'page'
  end

  def past_events
    @navigation = :community
    @document_title = "Community"
    @past_events = Event.past
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

    @return_link = {
      title: "Contribute",
      path: contribute_path,
    }

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

    @return_link = {
      title: "Contribute",
      path: contribute_path,
    }

    render layout: 'static'
  end

  def legacy
    # Read document
    document = File.read("#{Rails.root}/app/views/static/legacy.md")

    # Parse frontmatter
    @frontmatter = YAML.safe_load(document)
    @document_title = @frontmatter['title']
    @content = MarkdownPipeline.new.call(document)

    render layout: 'page'
  end

  def robots
    render 'robots.txt'
  end
end
