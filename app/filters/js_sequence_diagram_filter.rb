class JsSequenceDiagramFilter < Banzai::Filter
  def call(input)
    input.gsub(/```js_sequence_diagram(.+?)```/m) do |s|
      sequence = YAML.load($1)
    end
  end
end
