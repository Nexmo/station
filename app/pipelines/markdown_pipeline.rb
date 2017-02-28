class MarkdownPipeline < Banzai::Pipeline
  def initialize
    super(
      # As Markdown
      FrontmatterFilter,
      TabbedExamplesFilter,
      TabbedContentFilter,
      ModalFilter,
      JsSequenceDiagramFilter,
      MarkdownFilter,

      # As HTML
      UnfreezeFilter,
      CredentialsFilter,
      HeadingFilter,
      LabelFilter,
    )
  end
end
