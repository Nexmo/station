class TabbedExamplesFilter < Banzai::Filter
  def call(input)
    input.gsub(/```tabbed_examples(.+?)```/m) do |_s|
      config = YAML.safe_load($1)
      examples_path = "#{Rails.root}/#{config['source']}"

      examples = Dir["#{examples_path}/*"].map do |example_path|
        language = example_path.sub("#{examples_path}/", '')
        source = File.read(example_path)
        { language: language, source: source }
      end

      examples = sort_examples(examples)

      build_html(examples)
    end
  end

  private

  def sort_examples(examples)
    examples.sort_by do |example|
      case example[:language].downcase
      when 'curl' then 1
      when 'node' then 2
      when 'ruby' then 3
      when 'python' then 4
      when 'php' then 5
      when 'java' then 6
      when 'c#' then 7
      else 1000
      end
    end
  end

  def build_html(examples)
    examples_uid = "code-#{SecureRandom.uuid}"

    tabs = []
    content = []

    tabs << "<ul class='tabs tabs--code' data-tabs id='#{examples_uid}'>"
    content << "<div class='tabs-content tabs-content--code' data-tabs-content='#{examples_uid}'>"

    examples.each_with_index do |example, index|
      example_uid = "code-#{SecureRandom.uuid}"
      tabs << <<~HEREDOC
        <li class="tabs-title #{index.zero? ? 'is-active' : ''}" data-language="#{example[:language]}">
          <a href="##{example_uid}">#{language_label(example[:language])}</a>
        </li>
      HEREDOC

      highlighted_source = highlight(example[:source], example[:language])

      # Freeze to prevent Markdown formatting edge cases
      highlighted_source = "FREEZESTART#{Base64.urlsafe_encode64(highlighted_source)}FREEZEEND"

      content << <<~HEREDOC
        <div class="tabs-panel #{index.zero? ? 'is-active' : ''}" id="#{example_uid}" data-language="#{example[:language]}">
          <pre class="highlight #{example[:language]}"><code>#{highlighted_source}</code></pre>
        </div>
      HEREDOC
    end

    tabs << '</ul>'
    content << '</div>'

    # Wrap in an extra Div prevents markdown for formatting
    "<div>#{tabs.join('')}#{content.join('')}</div>"
  end

  def highlight(source, language)
    formatter = Rouge::Formatters::HTML.new
    lexer = language_to_lexer(language)
    formatter.format(lexer.lex(source))
  end

  def language_label(language)
    case language.downcase
    when 'c#' then '.NET'
    when 'node' then 'Node.js'
    when 'json' then 'JSON'
    when 'xml' then 'XML'
    else; language
    end
  end

  def language_to_lexer_name(language)
    language.downcase!
    case language.downcase
    when 'curl' then 'sh'
    when 'node' then 'javascript'
    when 'node.js' then 'javascript'
    when '.net' then 'c#'
    when 'ncco' then 'json'
    else; language
    end
  end

  def language_to_lexer(language)
    language = language_to_lexer_name(language)
    Rouge::Lexer.find(language) || Rouge::Lexer.find('text')
  end
end
