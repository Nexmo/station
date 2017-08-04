class DocumentationConstraint
  def self.documentation
    code_language.merge(product)
  end

  def self.code_language
    linkable_languages = language_configuration.map do |language, configuration|
      language unless configuration["linkable"] == false
    end
    { code_language: Regexp.new(linkable_languages.compact.join('|')) }
  end

  def self.product
    { product: /voice|messaging|verify|number-insight|account|concepts/ }
  end

  def self.product_with_parent
    { product: /voice\/sip|voice\/voice-api|messaging\/sms|messaging\/conversion-api|messaging\/sns|messaging\/us-short-codes|verify|number-insight|account|concepts/ }
  end

  def self.language_configuration
    @language_configuration ||= YAML.load_file("#{Rails.root}/config/code_languages.yml")
  end
end
