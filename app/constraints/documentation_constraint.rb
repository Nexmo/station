class DocumentationConstraint
  def self.documentation
    Nexmo::Markdown::CodeLanguage.route_constraint.merge(product_with_parent)
  end

  def self.product_with_parent
    { product: Regexp.new(product_with_parent_list.compact.join('|')) }
  end

  def self.product_with_parent_list
    if config.fetch('products', []).size.zero?
      raise ArgumentError, "The 'product' key in config/products.yml must be a list with at least one entry."
    else
      @product_with_parent_list ||= config.fetch('products', [])
    end
  end

  def self.config
    @config ||= YAML.safe_load(
      File.read("#{Rails.configuration.docs_base_path}/config/products.yml")
    )
  end
end
