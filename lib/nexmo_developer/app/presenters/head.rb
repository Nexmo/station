class Head
  attr_reader :items

  def initialize(items: nil)
    @items = items

    after_initialize!
  end

  def head_from_config(config)
    config = YAML.safe_load(open_config(config))
    {
      title: title(config),
      description: description(config),
      google_site_verification: config['google-site-verification'] || '',
      application_name: config['application-name'],
      og_image: file(config['og-image']),
      og_image_width: config['og-image-width'],
      og_image_height: config['og-image-height'],
      apple_touch_icon: file('apple-touch-icon.png'),
      favicon: file('favicon.ico'),
      favicon_32_squared: file('favicon-32x32.png'),
      manifest: file('manifest.json'),
      safari_pinned_tab: file('safari-pinned-tab.svg'),
      mstile_144_squared: file('mstile-144x144.png'),
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

  def title(config)
    raise "You must provide a 'title' parameter in header_meta.yml" if config['title'].blank?

    config['title']
  end

  def description(config)
    raise "You must provide an 'description' parameter in header_meta.yml" if config['description'].blank?

    config['description']
  end

  def file(file_name)
    raise "You must provide an #{file_name} file inside the public/meta directory" if file_does_not_exist?("#{Rails.configuration.docs_base_path}/public/meta/#{file_name}")

    "meta/#{file_name}"
  end
end
