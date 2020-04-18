class Topnav
  attr_reader :items
  def initialize(items: nil)
    @items = items

    after_initialize!
  end

  def navbar_items_from_config(config)
    config = YAML.safe_load(File.open(config))
    @items ||= config.map do |name, url_path|
      {
        name: I18n.t("layouts.partials.header.#{name.downcase}"),
        url: url_path,
        navigation: name.downcase,
      }
    end
  end

  private

  def after_initialize!
    raise 'You must provide a config/top_navigation.yml file in your documentation path.' unless File.exist?("#{Rails.configuration.docs_base_path}/config/top_navigation.yml")

    @items = navbar_items_from_config("#{Rails.configuration.docs_base_path}/config/top_navigation.yml")
  end
end
