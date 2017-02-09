class MarkdownPipeline < Banzai::Pipeline
  def initialize
    super(
      # As Markdown
      FrontmatterFilter,
      TabbedExamplesFilter,
      MarkdownFilter,

      # As HTML
      UnfreezeFilter,
      CredentialsFilter,
    )
  end
end
