class ResponseParserDecorator < OasParser::ResponseParser
  def formatted_json
    JSON.neat_generate(parse, {
      wrap: true,
      after_colon: 1,
    })
  end

  def html
    formatter = Rouge::Formatters::HTML.new
    lexer = Rouge::Lexer.find('json')
    highlighted_response = formatter.format(lexer.lex(formatted_json))

    output = <<~HEREDOC
      <pre class="highlight json"><code>#{highlighted_response}</code></pre>
    HEREDOC

    output.html_safe
  end
end
