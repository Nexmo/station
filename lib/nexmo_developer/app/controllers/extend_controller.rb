class ExtendController < ApplicationController
  before_action :set_navigation

  def index
    document_paths = Dir.glob("#{Rails.configuration.docs_base_path}/_extend/**/*.md")

    @extensions = document_paths.map do |document_path|
      document = File.read(document_path)
      frontmatter = YAML.safe_load(document)
      next unless frontmatter['published']

      title = frontmatter['title']
      description = frontmatter['description']
      tags = frontmatter['tags'] || []
      image = frontmatter['image'] || ''
      route = File.basename(document_path, '.*')
      { title: title, description: description, tags: tags, image: image, route: route }
    end.compact

    render layout: 'landing'
  end

  def show
    document_path = "#{Rails.configuration.docs_base_path}/_extend/#{params[:title]}.md"

    document = File.read(document_path)
    body = Nexmo::Markdown::Renderer.new.call(document)
    frontmatter = YAML.safe_load(document)
    title = frontmatter['title']
    description = frontmatter['description']
    tags = frontmatter['tags'] || []
    image = frontmatter['image'] || ''
    cta = frontmatter['cta'] || 'Use This'
    link = frontmatter['link'] || ''
    @extension = { title: title, body: body, image: image, description: description, tags: tags, link: link, cta: cta }

    render layout: 'page'
  end

  private

  def set_navigation
    @navigation = :extend
  end
end
