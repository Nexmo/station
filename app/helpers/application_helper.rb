IGNORED_PATHS = ['..', '.', '.DS_Store']
NAVIGATION_WEIGHT = YAML.load_file("#{Rails.root}/config/navigation.yml")["navigation_weight"]
FLATTEN_TREES = []

module ApplicationHelper
  def directory_hash(path, name=nil)
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
      sort_array << (item[:is_file?] && document_meta(item[:path])["navigation_weight"] ? document_meta(item[:path])["navigation_weight"] : 1000)
      sort_array
    end
    context
  end

  def path_to_url(path)
    path.gsub(/.*_documentation/, '').gsub('.md', '')
  end

  def first_link_in_directory(context)
    if context.any?
      if context.first[:is_file?]
        path_to_url(context.first[:path])
      else
        if context.first[:children]
          first_link_in_directory(context.first[:children])
        end
      end
    end
  end

  def normalised_title(item)
    (item[:is_file?] ? document_meta(item[:path])["title"] : I18n.t("menu.#{item[:title]}"))
  end

  def directory(context = directory_hash("#{Rails.root}/_documentation")[:children], root = true, received_flatten = false)
    s = []
    s << (root ? '<ul class="navigation js-navigation">' : '<ul>') unless received_flatten
    s << context.map do |child|
      flatten = FLATTEN_TREES.include? normalised_title(child)

      ss = []
      ss << '<li>' unless received_flatten

      unless flatten
        url = (child[:is_file?] ? path_to_url(child[:path]) : first_link_in_directory(child[:children]))
        ss << link_to(normalised_title(child), url, class: "#{url == request.path ? 'active' : ''}")
      end

      ss << directory(child[:children], false, flatten) if child[:children]
      ss << "</li>" unless received_flatten
      ss.join("\n")
    end
    s << '</ul>' unless received_flatten

    s.join("\n").html_safe
  end

  def document_meta(path)
    document = YAML.load_file(path)
  end
end
