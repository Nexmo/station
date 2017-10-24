CODE_LINE_HEIGHT = 22
CODE_PADDING = 20
CODE_CONTEXT = 0

class CodeFilter < Banzai::Filter
  def call(input)
    input.gsub(/```code(.+?)```/m) do |_s|
      config = YAML.safe_load($1)
      code = File.read("#{Rails.root}/#{config['source']}")
      language = File.extname("#{Rails.root}/#{config['source']}")[1..-1]
      lexer = language_to_lexer(language)

      highlighted_source = highlight(code, lexer)

      total_lines = code.lines.count

      # Minus one since lines are not zero-indexed
      from_line = (config['from_line'] || 0) - 1
      to_line = (config['to_line'] || total_lines) - 1

      focused_lines = to_line - from_line
      top = from_line * CODE_LINE_HEIGHT - (CODE_PADDING / 2) - CODE_CONTEXT
      height = (focused_lines * CODE_LINE_HEIGHT) + (CODE_PADDING * 2) + (CODE_CONTEXT * 2)

      line_numbers = (1..total_lines).map do |line_number|
        <<~HEREDOC
          <span class="focus__lines__line">#{line_number}</span>
        HEREDOC
      end

      <<~HEREDOC
        <div class="focus" style="height: #{height}px;">
          <div class="focus__lines" style="top: -#{top}px;">#{line_numbers.join('')}</div><pre class="highlight #{lexer.tag}" style="top: -#{top}px;"><code>#{highlighted_source}</code></pre>
        </div>
      HEREDOC
    end
  end

  private

  def highlight(source, lexer)
    formatter = Rouge::Formatters::HTML.new
    formatter.format(lexer.lex(source))
  end

  def language_to_lexer(language)
    Rouge::Lexer.find(language.downcase) || Rouge::Lexer.find('text')
  end
end
