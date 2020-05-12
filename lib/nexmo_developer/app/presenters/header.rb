class Header
  attr_reader :items
  def initialize(items: nil)
    @items = items

    after_initialize!
  end

  def header_from_config(config)
    config = YAML.safe_load(open_config(config))
    
    {
      name: config['name'],
      subtitle: config['subtitle'],
      logo_path: config['assets']['header_logo']['path'],
      logo_alt: config['assets']['header_logo']['alt'],
      sign_up_path: config['header']['links']['sign-up']['path'],
      sign_up_text_arr: config['header']['links']['sign-up']['text'],
      show_hiring_link: set_hiring_display(config)
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
    raise 'You must provide a config/business_info.yml file in your documentation path.' unless config_exist?("#{Rails.configuration.docs_base_path}/config/business_info.yml")

    @items = header_from_config("#{Rails.configuration.docs_base_path}/config/business_info.yml")
  end

  def set_hiring_display(config)
    raise 'You must provide a true or false value for the hiring display parameter inside the header section of the config/business_info.yml file' if config['header']['hiring'].try(:has_key?, :display).nil? || config['header']['hiring']['display'].blank?

    config['header']['hiring']['display']
  end
end
