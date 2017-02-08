class MarkdownPipeline < Banzai::Pipeline
  def initialize
    super(
      # As Markdown
      FrontmatterFilter,
      TabbedExamplesFilter,
      MarkdownFilter,

      # As HTML
      CredentialsFilter,
      ExamplesFilter,
    )
  end
end
