class Header
  def initialize
    after_initialize!
  end

  def sign_up_path
    @sign_up_path ||= config['header']['links']['sign-up']['path']
  end

  def sign_up_text
    @sign_up_text ||= config['header']['links']['sign-up']['text']
  end

  def sign_in_path
    @sign_in_path ||= config['header']['links']['sign-in']['path']
  end

  def sign_in_text
    @sign_in_text ||= config['header']['links']['sign-in']['text']
  end

  private

  def after_initialize!
    raise 'You must provide a config/business_info.yml file in your documentation path.' unless File.exist?("#{Rails.configuration.docs_base_path}/config/business_info.yml")
  end

  def config
    @config ||= YAML.safe_load(
      File.open("#{Rails.configuration.docs_base_path}/config/business_info.yml")
    )
  end
end
