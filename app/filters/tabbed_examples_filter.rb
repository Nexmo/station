class TabbedExamplesFilter < Banzai::Filter
  def call(input)
    input.gsub(/```tabbed_examples(.+?)```/m) do |s|
      config = YAML.load($1)
      examples_path = "#{Rails.root}/#{config["source"]}"

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
      when 'curl'; 1
      when 'node'; 2
      when 'ruby'; 3
      when 'python'; 4
      when 'php'; 5
      when 'java'; 6
      when 'c#'; 7
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
        <li class="tabs-title #{index == 0 ? 'is-active' : ''}" data-language="#{example[:language]}">
          <a href="##{example_uid}">#{language_label(example[:language])}</a>
        </li>
      HEREDOC

      highlighted_source = highlight(example[:source], example[:language])

      # Freeze to prevent Markdown formatting edge cases
      highlighted_source = "FREEZESTART#{Base64.encode64(highlighted_source)}FREEZEEND"

      content << <<~HEREDOC
        <div class="tabs-panel #{index == 0 ? 'is-active' : ''}" id="#{example_uid}" data-language="#{example[:language]}">
          <pre class="highlight #{example[:language]}"><code>#{highlighted_source}</code></pre>
        </div>
      HEREDOC
    end

    tabs << "</ul>"
    content << "</div>"

    # Wrap in an extra Div prevents markdown for formatting
    "<div>#{tabs.join('')}#{content.join('')}</div>"
  end

  def highlight(source, language)
    formatter = Rouge::Formatters::HTML.new
    lexer = language_to_lexer(language)
    formatter.format(lexer.lex(source))
  end

  def language_label(language)
    language = case language.downcase
    when 'c#'
      '.NET'
    when 'node'
      'Node.js'
    when 'json'
      'JSON'
    when 'xml'
      'XML'
    else
      language
    end
  end

  def language_to_lexer(language)
    language = case language.downcase
    when 'curl'
      'shell'
    when 'node'
      'javascript'
    else
      language.downcase
    end

    Rouge::Lexer.find(language) || Rouge::Lexer.find('text')
  end
end
