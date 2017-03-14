class TutorialsController < ApplicationController
  before_action :set_document

  def show
    # Read document
    document = File.read("#{Rails.root}/_tutorials/#{@document}.md")

    # Parse frontmatter
    @frontmatter = YAML.load(document)

    @content = MarkdownPipeline.new.call(document)

    render layout: 'static'
  end

  private

  def set_document
    @document = params[:document]
  end
end
