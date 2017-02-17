class MarkdownController < ApplicationController
  before_action :set_navigation
  before_action :set_product
  before_action :set_document

  def show
    # Read document
    document = File.read("#{Rails.root}/_documentation/#{@product}/#{@document}.md")

    # Parse frontmatter
    @frontmatter = YAML.load(document)

    @content = MarkdownPipeline.new.call(document)

    render layout: 'documentation'
  end

  private

  def set_navigation
    @navigation = :documentation
  end

  def set_product
    @product = params[:product]
  end

  def set_document
    @document = params[:document]
  end
end
