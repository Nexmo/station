class Head
  attr_reader :items
  def initialize(items: nil)
    @items = items

    after_initialize!
  end

  def header_from_config(config)
    config = YAML.safe_load(open_config(config))
    {
      title: config['title'],
      description: config['description'],
      google_site_verification: config['google-site-verification'],
      application_name: config['application-name'],
      og_image: config['og-image'],
      og_image_width: config['og-image-width'] || 835,
      og_image_height: config['og-image-height'] || 437
    }
  end

  def open_config(config)
    File.open(config)
  end

  def config_exist?(path)
    File.exist?(path)
  end

  private

  def after_initialize!
    raise 'You must provide a config/business_info.yml file in your documentation path.' unless config_exist?("#{Rails.configuration.docs_base_path}/config/header_meta.yml")

    @items = header_from_config("#{Rails.configuration.docs_base_path}/config/header_meta.yml")
  end
end
