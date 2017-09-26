class String
  def render_markdown
    MarkdownPipeline.new.call(self).html_safe
  end
end
