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
      case content[:frontmatter]['title'].downcase
      when 'curl' then 1
      when 'node' then 2
      when 'node.js' then 2
      when 'java' then 3
      when 'c#' then 4
      when 'php' then 5
      when 'python' then 6
      when 'ruby' then 7
      else content[:frontmatter]['menu_weight'] || 999
      end
    end
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
        <li class="tabs-title #{index.zero? ? 'is-active' : ''}" data-language="#{content[:frontmatter]['language']}">
          <a href="##{content_uid}">#{content[:frontmatter]['title']}</a>
        </li>
      HEREDOC

      markdownified_source = MarkdownPipeline.new.call(content[:source])

      # Freeze to prevent Markdown formatting edge cases
      markdownified_source = "FREEZESTART#{Base64.urlsafe_encode64(markdownified_source)}FREEZEEND"

      body << <<~HEREDOC
        <div class="tabs-panel #{index.zero? ? 'is-active' : ''}" id="#{content_uid}">
          #{markdownified_source}
        </div>
      HEREDOC
    end

    tabs << '</ul>'
    body << '</div>'

    # Wrap in an extra Div prevents markdown for formatting
    "<div>#{tabs.join('')}#{body.join('')}</div>"
  end
end
