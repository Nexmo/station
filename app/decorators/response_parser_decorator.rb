class ResponseParserDecorator < OasParser::ResponseParser
  def formatted_json
    JSON.neat_generate(parse, {
      wrap: true,
      after_colon: 1,
    })
  end

  def html(format = 'application/json')
    formatter = Rouge::Formatters::HTML.new

    case format
    when 'application/json'
      lexer = Rouge::Lexer.find('json')
      highlighted_response = formatter.format(lexer.lex(formatted_json))
    when 'text/xml'
      lexer = Rouge::Lexer.find('xml')
      highlighted_response = formatter.format(lexer.lex(Crack::JSON.parse(parse.to_json).to_xml))
    end

    output = <<~HEREDOC
      <pre class="highlight json"><code>#{highlighted_response}</code></pre>
    HEREDOC

    output.html_safe
  end
end
