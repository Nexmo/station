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
      og_image: set_og_image,
      og_image_width: 835,
      og_image_height: 437,
      apple_touch_icon: set_apple_touch_icon,
      favicon: set_favicon,
      favicon_32_squared: set_favicon_squared,
      manifest: set_manifest,
      safari_pinned_tab: set_safari_pinned_tab,
      mstile_144_squared: set_mstile_144_squared,
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

  def set_og_image
    raise "You must provide an 'og.png' file inside the public/meta directory" if file_does_not_exist?("#{Rails.configuration.docs_base_path}/public/meta/og.png")

    'meta/og.png'   
  end

  def set_apple_touch_icon
    raise "You must provide an 'apple-touch-icon.png' file inside the public/meta directory" if file_does_not_exist?("#{Rails.configuration.docs_base_path}/public/meta/apple-touch-icon.png")

    'meta/apple-touch-icon.png'   
  end

  def set_favicon
    raise "You must provide an 'favicon.ico' file inside the public/meta directory" if file_does_not_exist?("#{Rails.configuration.docs_base_path}/public/meta/favicon.ico")

    'meta/favicon.ico'   
  end

  def set_favicon_squared
    raise "You must provide an 'favicon-32x32.png' file inside the public/meta directory" if file_does_not_exist?("#{Rails.configuration.docs_base_path}/public/meta/favicon-32x32.png")

    'meta/favicon-32x32.png'   
  end

  def set_manifest
    raise "You must provide an 'manifest.json' file inside the public/meta directory" if file_does_not_exist?("#{Rails.configuration.docs_base_path}/public/meta/manifest.json")

    'meta/manifest.json'   
  end

  def set_safari_pinned_tab
    raise "You must provide an 'safari-pinned-tab.svg' file inside the public/meta directory" if file_does_not_exist?("#{Rails.configuration.docs_base_path}/public/meta/safari-pinned-tab.svg")

    'meta/safari-pinned-tab.svg'   
  end

  def set_mstile_144_squared
    raise "You must provide an 'mstile-144x144.png' file inside the public/meta directory" if file_does_not_exist?("#{Rails.configuration.docs_base_path}/public/meta/mstile-144x144.png")

    'meta/mstile-144x144.png'   
  end
end
