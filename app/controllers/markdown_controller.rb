class MarkdownController < ApplicationController
  caches_action :show

  before_action :set_navigation
  before_action :set_product
  before_action :set_document

  def show
    # Read document
    @document_path = "_documentation/#{@product}/#{@document}.md"
    document = File.read("#{Rails.root}/#{@document_path}")

    # Parse frontmatter
    @frontmatter = YAML.safe_load(document)

    @document_title = @frontmatter['title']

    @content = MarkdownPipeline.new.call(document)

    if !Rails.env.development? && @frontmatter['wip']
      @show_feedback = false
      render 'wip', layout: 'documentation'
    else
      render layout: 'documentation'
    end
  end

  private

  def set_navigation
    @navigation = :documentation
    @side_navigation_extra_links = {
      'Tutorials' => '/tutorials',
    }
  end

  def set_product
    @product = params[:product]
  end

  def set_document
    @document = params[:document]
  end
end
