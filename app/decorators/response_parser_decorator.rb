class ResponseParserDecorator < OasParser::ResponseParser
  def formatted_json
    JSON.neat_generate(parse, {
      wrap: true,
      after_colon: 1,
    })
  end

  def formatted_xml(xml_options)
    root = xml_options ? xml_options['name'] : false
    parse.to_xml(dasherize: false, root: root)
  end

  def html(format = 'application/json', xml_options: nil)
    formatter = Rouge::Formatters::HTML.new

    case format
    when 'application/json'
      lexer = Rouge::Lexer.find('json')
      highlighted_response = formatter.format(lexer.lex(formatted_json))
    when 'text/xml'
      lexer = Rouge::Lexer.find('xml')
      highlighted_response = formatter.format(lexer.lex(formatted_xml(xml_options)))
    end

    output = <<~HEREDOC
      <pre class="highlight json"><code>#{highlighted_response}</code></pre>
    HEREDOC

    output.html_safe
  end
end
