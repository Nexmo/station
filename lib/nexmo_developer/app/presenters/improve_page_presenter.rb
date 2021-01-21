class ImprovePagePresenter
  def initialize(document_path)
    @document_path = document_path
  end

  def github_url
    @github_url ||= "https://github.com/#{docs_repo}/blob/#{ENV.fetch('branch', 'master')}/#{path_to_url}"
  end

  def docs_repo
    @docs_repo ||= begin
      path_to_url.start_with?('lib/nexmo_developer/app/') ? 'nexmo/station' : YAML.safe_load(File.open("#{Rails.configuration.docs_base_path}/config/business_info.yml"))['docs_repo']
    end
  end

  def path_to_url
    @path_to_url ||= begin
      @document_path&.gsub!("#{Rails.configuration.docs_base_path}/", '')
      @document_path.start_with?('app/views') ? @document_path.prepend('lib/nexmo_developer/') : @document_path
    end
  end
end
