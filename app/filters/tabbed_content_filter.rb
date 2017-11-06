class TabbedContentFilter < Banzai::Filter
  def call(input)
    input.gsub(/```tabbed_content(.+?)```/m) do |_s|
      config = YAML.safe_load($1)
      contents_path = "#{Rails.root}/#{config['source']}"

      contents = Dir["#{contents_path}/*.md"].map do |content_path|
        source = File.read(content_path)
        frontmatter = YAML.safe_load(source)
        { frontmatter: frontmatter, source: source }
      end

      contents = sort_contents(contents)

      build_html(contents)
    end
  end

  private

  def sort_contents(contents)
    contents.sort_by do |content|
      if content[:frontmatter]['language']
        language_configuration[content[:frontmatter]['language']]['weight']
      else
        content[:frontmatter]['menu_weight'] || 999
      end
    end
  end

  def active_class(index, language, options = {})
    if options[:code_language]
      'is-active' if language == options[:code_language]
    elsif index.zero?
      'is-active'
    end
  end

  def language_data(content)
    language = content[:frontmatter]['language']
    return unless language

    configuration = language_configuration[language]
    return unless configuration

    <<~HEREDOC
      data-language="#{language}"
      data-language-linkable="#{configuration['linkable'] != false}"
    HEREDOC
  end

  def build_html(contents)
    contents_uid = "code-#{SecureRandom.uuid}"

    tabs = []
    body = []

    tabs << "<ul class='tabs tabs--content' data-tabs id='#{contents_uid}'>"
    body << "<div class='tabs-content tabs-content--content' data-tabs-content='#{contents_uid}'>"

    contents.each_with_index do |content, index|
      content_uid = "code-#{SecureRandom.uuid}"
      tabs << <<~HEREDOC
        <li class="tabs-title #{active_class(index, content[:frontmatter]['language'], options)}" #{language_data(content)}">
          <a href="##{content_uid}">#{content[:frontmatter]['title']}</a>
        </li>
      HEREDOC

      markdownified_source = MarkdownPipeline.new(options).call(content[:source])

      # Freeze to prevent Markdown formatting edge cases
      markdownified_source = "FREEZESTART#{Base64.urlsafe_encode64(markdownified_source)}FREEZEEND"

      body << <<~HEREDOC
        <div class="tabs-panel #{active_class(index, content[:frontmatter]['language'], options)}" id="#{content_uid}" aria-hidden="#{!!!active_class(index, content[:frontmatter]['language'], options)}">
          #{markdownified_source}
        </div>
      HEREDOC
    end

    tabs << '</ul>'
    body << '</div>'

    # Wrap in an extra Div prevents markdown for formatting
    "<div>#{tabs.join('')}#{body.join('')}</div>"
  end

  def language_configuration
    @language_configuration ||= YAML.load_file("#{Rails.root}/config/code_languages.yml")
  end
end
