class MarkdownPipeline < Banzai::Pipeline
  def initialize
    super(
      # As Markdown
      FrontmatterFilter,
      InlineEscapeFilter,
      TabbedExamplesFilter,
      TabbedContentFilter,
      ModalFilter,
      JsSequenceDiagramFilter,
      MarkdownFilter,

      # As HTML
      CredentialsFilter,
      HeadingFilter,
      LabelFilter,
      BreakFilter,
      UnfreezeFilter,
    )
  end
end
