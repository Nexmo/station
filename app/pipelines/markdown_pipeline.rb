class MarkdownPipeline < Banzai::Pipeline
  def initialize(options = {})
    Rails.logger.info 'MarkdownPipeline#initialize'

    super(
      # As Markdown
      FrontmatterFilter,
      InlineEscapeFilter,
      BlockEscapeFilter,
      AnchorFilter,
      TooltipFilter,
      CollapsibleFilter,
      TabbedExamplesFilter.new(options),
      TabbedContentFilter.new(options),
      CodeFilter,
      ModalFilter,
      JsSequenceDiagramFilter,
      PartialFilter,
      IconFilter,
      LanguageFilter,
      MarkdownFilter,

      # As HTML
      CredentialsFilter,
      HeadingFilter,
      LabelFilter,
      BreakFilter,
      UnfreezeFilter,
      ExternalLinkFilter
    )
  end
end
