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
      og_image: set_file('og.png'),
      og_image_width: 835,
      og_image_height: 437,
      apple_touch_icon: set_file('apple-touch-icon.png'),
      favicon: set_file('favicon.ico'),
      favicon_32_squared: set_file('favicon-32x32.png'),
      manifest: set_file('manifest.json'),
      safari_pinned_tab: set_file('safari-pinned-tab.svg'),
      mstile_144_squared: set_file('mstile-144x144.png'),
    }
  end

  def open_config(config)
    File.open(config)
  end

  def config_exist?(path)
    File.exist?(path)
  end

  def file_does_not_exist?(path)
    !File.exist?(path)
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

  def set_file(file_name)
    raise "You must provide an #{file_name} file inside the public/meta directory" if file_does_not_exist?("#{Rails.configuration.docs_base_path}/public/meta/#{file_name}")

    "meta/#{file_name}"
  end
end
