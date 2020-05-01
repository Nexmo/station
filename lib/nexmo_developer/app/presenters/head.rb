class Head
  attr_reader :items
  def initialize(items: nil)
    @items = items

    after_initialize!
  end

  def head_from_config(config)
    config = YAML.safe_load(open_config(config))
    {
      title: set_title(config),
      description: set_description(config),
      google_site_verification: config['google-site-verification'] || '',
      application_name: config['application-name'],
      og_image: set_og_image(config),
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
    raise 'You must provide a config/header_meta.yml file in your documentation path.' unless config_exist?("#{Rails.configuration.docs_base_path}/config/header_meta.yml")

    @items = head_from_config("#{Rails.configuration.docs_base_path}/config/header_meta.yml")
  end

  def set_title(config)
    raise "You must provide a 'title' parameter in header_meta.yml" if config['title'].blank?

    config['title']
  end

  def set_description(config)
    raise "You must provide an 'description' parameter in header_meta.yml" if config['description'].blank?

    config['description']
  end

  def set_og_image(config)
    raise "You must provide an 'og-image' parameter in header_meta.yml" if config['og-image'].blank?

    config['og-image']    
  end
end
