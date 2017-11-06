IGNORED_PATHS = ['..', '.', '.DS_Store'].freeze
NAVIGATION_WEIGHT = YAML.load_file("#{Rails.root}/config/navigation.yml")['navigation_weight']
FLATTEN_TREES = [].freeze
COLLAPSIBLE = ['Messaging', 'SMS', 'Conversion API', 'SNS', 'US Short Codes', 'Voice', 'Number Insight', 'Account', 'Global', 'SIP', 'Voice API'].freeze

module ApplicationHelper
  def search_enabled?
    return false unless ENV['SEARCH_URL']
    true
  end

  def theme
    return unless ENV['THEME']
    "theme--#{ENV['THEME']}"
  end

  def title
    if @product && @document_title
      "Nexmo Developer | #{@product.titleize} > #{@document_title}"
    elsif @document_title
      "Nexmo Developer | #{@document_title}"
    else
      'Nexmo Developer'
    end
  end

  def directory_hash(path, name = nil)
    data = { title: (name || path), path: path }
    data[:children] = []
    Dir.foreach(path) do |entry|
      next if IGNORED_PATHS.include? entry
      full_path = File.join(path, entry)
      if File.directory?(full_path)
        data[:children] << directory_hash(full_path, entry)
      else
        data[:children] << { title: entry, path: full_path, is_file?: true }
      end
    end

    sort_navigation(data)
  end

  def sort_navigation(context)
    context[:children].sort_by! do |item|
      sort_array = []
      sort_array << (NAVIGATION_WEIGHT[normalised_title(item)] || 1000)
      sort_array << (item[:is_file?] ? 1 : 0)
      sort_array << (item[:is_file?] && document_meta(item[:path])['navigation_weight'] ? document_meta(item[:path])['navigation_weight'] : 1000)
      sort_array
    end
    context
  end

  def path_to_url(path)
    path.gsub(/.*#{@namespace_root}/, '').gsub('.md', '')
  end

  def first_link_in_directory(context)
    return nil if context.empty?
    if context.first[:is_file?]
      path_to_url(context.first[:path])
    elsif context.first[:children]
      first_link_in_directory(context.first[:children])
    end
  end

  def normalised_title(item)
    (item[:is_file?] ? document_meta(item[:path])['title'] : I18n.t("menu.#{item[:title]}"))
  end

  def sidenav(path)
    context = directory_hash(path)[:children]

    if params[:namespace].present?
      context = [{
        title: params[:namespace],
        path: path.gsub('app/views', ''),
        children: context,
      }]
    end

    directory(context, true, false)
  end

  def directory(context = directory_hash("#{Rails.root}/_documentation")[:children], root = true, received_flatten = false)
    s = []
    s << (root ? "<ul class='navigation js-navigation navigation--#{params[:namespace] || 'documentation'}'>" : '<ul>') unless received_flatten
    s << context.map do |child|
      flatten = FLATTEN_TREES.include? normalised_title(child)
      class_name = (COLLAPSIBLE.include? normalised_title(child)) ? 'js--collapsible' : ''

      ss = []
      ss << "<li class='#{class_name} navigation-item navigation-item--#{normalised_title(child).parameterize}'>" unless received_flatten

      unless flatten
        url = (child[:is_file?] ? path_to_url(child[:path]) : first_link_in_directory(child[:children]))
        has_active_class = (request.path == url) || request.path.start_with?("#{url}/")
        ss << link_to(normalised_title(child), url, class: "#{has_active_class ? 'active' : ''}")
      end

      ss << directory(child[:children], false, flatten) if child[:children]
      ss << '</li>' unless received_flatten
      ss.join("\n")
    end

    if root && @side_navigation_extra_links
      s << '<hr>'
      @side_navigation_extra_links.each do |title, path|
        s << <<~HEREDOC
          <a href="#{path}" class="#{path == request.path ? 'active' : ''}">#{title}</a>
        HEREDOC
      end
    end

    s << '</ul>' unless received_flatten

    s.join("\n").html_safe
  end

  def document_meta(path)
    YAML.load_file(path)
  end

  def render_request(definition_name, path, method)
    base_path = "_open_api_requests/#{definition_name + path}/#{method}/"

    markdown = <<~HEREDOC
      ```tabbed_examples
      source: #{base_path}
      ```
    HEREDOC

    tabbed_examples = TabbedExamplesFilter.new.call(markdown)
    UnfreezeFilter.new.call(tabbed_examples).html_safe
  end
end
