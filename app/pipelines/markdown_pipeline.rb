class MarkdownPipeline < Banzai::Pipeline
  def initialize
    Rails.logger.info 'MarkdownPipeline#initialize'

    super(
      # As Markdown
      FrontmatterFilter,
      InlineEscapeFilter,
      TabbedExamplesFilter,
      TabbedContentFilter,
      CodeFilter,
      ModalFilter,
      JsSequenceDiagramFilter,
      PartialFilter,
      MarkdownFilter,

      # As HTML
      CredentialsFilter,
      HeadingFilter,
      LabelFilter,
      BreakFilter,
      UnfreezeFilter,
      ExternalLinkFilter,
    )
  end
end
