class DocumentationConstraint
  def self.all
    {
      code_language: code_language,
      product: product,
    }
  end

  def self.code_language
    /curl|node|java|dotnet|php|python|ruby|csharp/
  end

  def self.product
    /voice|messaging|verify|number-insight|account|concepts/
  end
end
