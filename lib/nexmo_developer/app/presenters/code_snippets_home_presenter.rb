class CodeSnippetsHomePresenter
  def code_snippets
    @code_snippets = []
  end

  def cache_key
    @cache_key ||= config['code_snippets'].join('-')
  end

  def config
    @config ||= YAML.safe_load(
      File.open("#{Rails.configuration.docs_base_path}/config/business_info.yml")
    )
  end
end
