class JsSequenceDiagramFilter < Banzai::Filter
  def call(input)
    input.gsub(/```js_sequence_diagram(.+?)```/m) do |s|
      <<~HEREDOC
      <div class="diagram">
        #{$1}
      </div>
      HEREDOC
    end
  end
end
