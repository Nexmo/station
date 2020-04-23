require 'byebug'

class Header
  attr_reader :items
  def initialize(items: nil)
    @items = items

    after_initialize!
  end

  def header_from_config(config)
    config = YAML.safe_load(File.open(config))
    @items = [
      {
        name: config['name'],
        subtitle: config['subtitle'],
        logo_path: config['header']['assets']['logo']['path'],
        logo_alt: config['header']['assets']['logo']['alt'],
        sign_up_path: config['header']['links']['sign-up']['path'],
        sign_up_text_arr: config['header']['links']['sign-up']['text']
      }
    ]
  end

  private

  def after_initialize!
    raise 'You must provide a config/business_info.yml file in your documentation path.' unless File.exist?("#{Rails.configuration.docs_base_path}/config/business_info.yml")

    @items = header_from_config("#{Rails.configuration.docs_base_path}/config/business_info.yml")
  end
end
