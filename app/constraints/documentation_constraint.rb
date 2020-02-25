class DocumentationConstraint
  def self.documentation
    Nexmo::Markdown::CodeLanguage.route_constraint.merge(product_with_parent)
  end


  def self.product_with_parent
    { product: Regexp.new(product_with_parent_list.compact.join('|')) }
  end

  def self.product_with_parent_list
    @product_with_parent_list ||= config.fetch('products', [])
  end

  def self.config
    @config ||= YAML.safe_load(
      File.read("#{Rails.configuration.docs_base_path}/config/products.yml")
    )
  end
end
