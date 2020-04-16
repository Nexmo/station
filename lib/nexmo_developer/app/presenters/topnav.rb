class Topnav
  attr_reader :items

  # rubocop:disable Metrics/ParameterLists
  def initialize(items: nil)
    @items = items

    after_initialize!
  end
  # rubocop:enable Metrics/ParameterLists

  def navbar_items_from_config(config)
    config = YAML::load(File.open(config))
    @items ||= config.map do |name, url_path| {
      name: configure_item_name(name),
      url: configure_item_url_path(url_path), 
      navigation: configure_item_navigation(name)
    }
    end
    return @items
  end

  def configure_item_name(name)
    name_comparison = name.downcase
    case name_comparison
    when 'documentation'
      I18n.t('.documentation')
    when 'use-cases'
      I18n.t('.use-cases')
    when 'api'
      I18n.t('.api-reference')
    when 'community'
      I18n.t('.community')
    when 'extend'
      I18n.t('.extend')
    when 'tools'
      I18n.t('.sdks-and-tools')
    else
      name
    end
  end

  def configure_item_url_path(url_path)
    case url_path
    when 'documentation'
      documentation_path(locale: I18n.locale)
    when 'use-cases'
      use_cases_path
    when 'api'
      api_path
    when 'community'
      static_path('community')
    when 'extend'
      extend_path
    when 'tools'
      tools_path
    else
      url_path
    end
  end

  def configure_item_navigation(name)
    name.parameterize.underscore
  end

  def navbar_items_default
    @items ||= [
      ['Documentation', '/documentation'],
      ['Use Cases', '/use-cases'],
      ['API', '/api'],
      ['Tools', '/tools'],
      ['Community', '/community'],
      ['Extend', '/extend']
    ]
  end

  private

  def after_initialize!
    if File.exist?("#{Rails.configuration.docs_base_path}/config/top_navigation.yml")
      @items = navbar_items_from_config("#{Rails.configuration.docs_base_path}/config/top_navigation.yml")
    else
      @items = navbar_items_default
    end
  end
end