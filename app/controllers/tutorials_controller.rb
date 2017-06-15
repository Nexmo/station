class TutorialsController < ApplicationController
  before_action :set_document
  before_action :set_navigation

  def index
    @product = params['product']
    document_paths = Dir.glob("#{Rails.root}/_tutorials/**/*.md")

    @tutorials = document_paths.map do |document_path|
      document = File.read(document_path)
      frontmatter = YAML.safe_load(document)
      title = frontmatter['title']
      description = frontmatter['description']
      products = frontmatter['products'].split(',').map(&:strip)

      origin = Pathname.new("#{Rails.root}/_documentation")
      document_path = Pathname.new(document_path)
      relative_path = "/#{document_path.relative_path_from(origin)}".gsub('.md', '')

      if params['product']
        if products.include?(@product)
          { title: title, description: description, path: relative_path, body: document, products: products }
        else
          nil
        end
      else
        { title: title, description: description, path: relative_path, body: document, products: products }
      end
    end

    @tutorials.compact!

    @title = 'Tutorials'



    render layout: 'documentation-index'
  end

  def show
    # Read document
    document = File.read("#{Rails.root}/_tutorials/#{@document}.md")

    # Parse frontmatter
    @frontmatter = YAML.safe_load(document)
    @title = @frontmatter['title']

    @content = MarkdownPipeline.new.call(document)

    render layout: 'static'
  end

  private

  def set_document
    @document = params[:document]
  end

  def set_navigation
    @navigation = :documentation
    @side_navigation_extra_links = {
      'Tutorials' => '/tutorials',
    }
  end
end
