class MarkdownController < ApplicationController
  before_action :set_product
  before_action :set_document

  def show
    renderer = HTML.new

    markdown = Redcarpet::Markdown.new(renderer, {
      no_intra_emphasis: true,
      tables: true,
      strikethrough: true,
      superscript: true,
      underline: true,
      highlight: true,
      fenced_code_blocks: true,
      disable_indented_code_blocks: true,
    })

    # Read document
    document = File.read("#{Rails.root}/_documentation/#{@product}/#{@document}.md")

    # Parse frontmatter
    @frontmatter = YAML.load(document)

    # Remove frontmatter from the document
    document = document.gsub(/(---.+?---)/mo, '')

    # Render markdown
    @content = markdown.render(document)

    render layout: 'documentation'
  end

  private

  def set_product
    @product = params[:product]
  end

  def set_document
    @document = params[:document]
  end
end
