class MarkdownPipeline < Banzai::Pipeline
  def initialize
    super(FrontmatterFilter, MarkdownFilter)
  end
end
