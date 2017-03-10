module NavigationHelper
  def navigation_from_content(content)
    document = build_document(content)

    nodes = ['<ul>']
    last_node = nil

    document.css('.reveal').remove

    document.css('h2,h3,h4,h5,h6').each do |heading|
      if last_node == nil || heading.name == last_node.name
        # Do nothing (cleaner than adding wrapping furterh conditions
      elsif heading.name >= last_node.name # e.g. h2 -> h3
        nodes << '<ul>'
      else # e.g. h3 -> h2
        nodes << '</li></ul>'
      end

      nodes << "<li><a href='##{heading.text.parameterize}'>#{heading.text}</a>"
      last_node = heading
    end
    nodes << '</li></ul>'
    nodes.join("\n").html_safe
  end

  private

  def build_document(content)
    Nokogiri::HTML::DocumentFragment.parse(@content)
  end
end
