class DocumentationConstraint
  def self.all
    {
      code_language: code_language,
      product: product,
    }
  end

  def self.code_language
    Regexp.new(language_configuration.keys.join('|'))
  end

  def self.product
    /voice|messaging|verify|number-insight|account|concepts/
  end

  def self.language_configuration
    @language_configuration ||= YAML.load_file("#{Rails.root}/config/code_languages.yml")
  end
end
