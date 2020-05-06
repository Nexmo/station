class Product
  # TODO: return instances
  def self.all
    raise "Application requires 'products.yml' inside /config folder in documentation path" unless "#{Rails.configuration.docs_base_path}/config/products.yml"

    config = YAML.safe_load(File.open("#{Rails.configuration.docs_base_path}/config/products.yml"))

    config['products']
  end

  def self.normalize_title(product)
    return 'SMS' if product == 'messaging/sms'
    return 'Voice' if product == 'voice/voice-api'
    return 'Number Insight' if product == 'number-insight'
    return 'Messages' if product == 'messages'
    return 'Dispatch' if product == 'dispatch'
    return 'Client SDK' if product == 'client-sdk'
    return 'Subaccounts' if product == 'account/subaccounts'

    product.camelcase
  end

  def self.filter_products_for_dropdown(item_list) # use_cases || tutorials
    products = all.select{|p| p['dropdown'] == true}
    products_mapped = []

    products.each do |p|
      item_list.each do |i|
        if i.products.include?(p['path'])
          products_mapped << p
        end
        products_mapped
      end
    end

    products_mapped
  end
end