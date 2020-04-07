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
    @items ||= config.map do |item|
      name = item[0],
      url = item[1]
    end
    return @items
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