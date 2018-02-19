OPEN_API_PRODUCTS = %w(
  sms
  media
  number-insight
)

class OpenApiConstraint
  def self.products
    { code_language: Regexp.new(OPEN_API_PRODUCTS.join('|')) }
  end
end
