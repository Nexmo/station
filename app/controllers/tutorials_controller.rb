class TutorialsController < ApplicationController
  before_action :set_document

  def index
    document_paths = Dir.glob("#{Rails.root}/_tutorials/**/*.md")

    @tutorials = document_paths.map do |document_path|
      document = File.read(document_path)
      frontmatter = YAML.load(document)
      title = frontmatter['title']
      description = frontmatter['description']

      origin = Pathname.new("#{Rails.root}/_documentation")
      document_path = Pathname.new(document_path)
      relative_path = "/#{document_path.relative_path_from(origin)}".gsub('.md', '')

      { title: title, description: description, path: relative_path, body: document }
    end
  end

  def show
    # Read document
    document = File.read("#{Rails.root}/_tutorials/#{@document}.md")

    # Parse frontmatter
    @frontmatter = YAML.load(document)
    @title = @frontmatter['title']

    @content = MarkdownPipeline.new.call(document)

    render layout: 'static'
  end

  private

  def set_document
    @document = params[:document]
  end
end
