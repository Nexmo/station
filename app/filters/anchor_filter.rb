class AnchorFilter < Banzai::Filter
  def call(input)
    input.gsub(/^⚓\ (.+?)\n/) do
      <<~HEREDOC
        <a name="#{$1.parameterize}"></a>
      HEREDOC
    end
  end
end
