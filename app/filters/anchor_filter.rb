class AnchorFilter < Banzai::Filter
  def call(input)
    input.gsub(/^[u{⚓️}](.+?)\n/) do
      <<~HEREDOC
        <a name="#{$1.parameterize}"></a>
      HEREDOC
    end
  end
end
