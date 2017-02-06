IGNORED_FILES = ['.DS_Store']
NAVIGATION_WEIGHT = YAML.load_file("#{Rails.root}/config/navigation.yml")["navigation_weight"]
FLATTEN_TREES = ['Messaging']

module ApplicationHelper
  def directory_hash(path, name=nil)
    data = { title: (name || path), path: path }
    data[:children] = children = []
    Dir.foreach(path) do |entry|
      next if (entry == '..' || entry == '.')
      full_path = File.join(path, entry)
      if File.directory?(full_path)
        children << directory_hash(full_path, entry)
      else
        children << { title: entry, path: full_path, is_file?: true }
      end
    end
    return data
  end

  def clean(context)
    context.reject do |item|
      IGNORED_FILES.include? item[:title]
    end
  end

  def sort_by_directory_and_weight(context)
    context.sort_by do |item|
      sort_array = []

      sort_array << (NAVIGATION_WEIGHT[normalised_title(item)] || 1000)
      sort_array << (item[:is_file?] ? 1 : 0)
      sort_array << (item[:is_file?] && document_meta(item[:path])["navigation_weight"] ? document_meta(item[:path])["navigation_weight"] : 1000)

      sort_array
    end
  end

  def path_to_url(path)
    path.gsub(/.*_documentation/, '').gsub('.md', '')
  end

  def first_link_in_directory(context)
    context = clean(context)
    context = sort_by_directory_and_weight(context)

    if context.any?
      if context.first[:is_file?]
        path_to_url(context.first[:path])
      else
        if context.first[:children]
          first_link_in_directory(context.first[:children])
        else
          '#'
        end
      end
    else
      '#'
    end
  end

  def normalised_title(item)
    (item[:is_file?] ? document_meta(item[:path])["title"] : I18n.t("menu.#{item[:title]}"))
  end

  def directory(context = directory_hash("#{Rails.root}/_documentation")[:children], received_flatten = false)
    s = []
    s << '<ul>' unless received_flatten

    context = clean(context)
    context = sort_by_directory_and_weight(context)

    s << context.map do |child|
      ss = []

      flatten = FLATTEN_TREES.include? normalised_title(child)

      unless flatten
        ss << "<li>"
        url = (child[:is_file?] ? path_to_url(child[:path]) : first_link_in_directory(child[:children]))
        ss << link_to(normalised_title(child), url, class: "#{url == request.path ? 'active' : ''}")
        ss << "</li>"
      end

      ss << directory(child[:children], flatten) if child[:children]
      ss.join('')
    end
    s << '</ul>' unless received_flatten

    s.join('').html_safe
  end

  def document_meta(path)
    document = YAML.load_file(path)
  end
end
