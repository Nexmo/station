class MediaFilter < Banzai::Filter
  def call(input)
    input.gsub(/^(.*)\s->\s(.*)<-$/) do
      media_part = MarkdownPipeline.new.call($1)
      body_part = MarkdownPipeline.new.call($2)
      output = <<~HEREDOC
        <div class="media">
          <div class="media-media">#{media_part}</div>
          <div class="media-body">#{body_part}</div>
        </div>
      HEREDOC
    end
  end
end
