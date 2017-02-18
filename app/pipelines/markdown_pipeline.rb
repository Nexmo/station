class MarkdownPipeline < Banzai::Pipeline
  def initialize
    super(
      # As Markdown
      FrontmatterFilter,
      TabbedExamplesFilter,
      TabbedContentFilter,
      MarkdownFilter,

      # As HTML
      UnfreezeFilter,
      CredentialsFilter,
      HeadingFilter,
    )
  end
end
