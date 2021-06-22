class CodeSnippetsHomePresenter
  def code_snippets
    @code_snippets ||= config['code_snippets'].map do |snippet|
      Nexmo::Markdown::Renderer.new.call(
        <<-STRING
          ```code_snippets
          source: '#{snippet}'
          ```
        STRING
      )
    end
  end

  def config
    @config ||= YAML.safe_load(
      File.open("#{Rails.configuration.docs_base_path}/config/business_info.yml")
    )
  end
end
