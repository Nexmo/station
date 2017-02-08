class ExamplesFilter < Banzai::Filter
  def call(input)
    @input = input
    parse_html
    wrap_code_blocks
    @input.to_html
  end

  private

  def wrap_code_blocks
    nodes = @input.css 'pre.highlight'
    nodes.wrap "<div class='foobar'></div>"
  end

  def parse_html
    @input = Nokogiri::HTML::DocumentFragment.parse(@input)
  end
end
