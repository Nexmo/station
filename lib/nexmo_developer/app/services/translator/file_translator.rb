module Translator
  class FileTranslator
    attr_reader :doc_path

    def initialize(doc_path)
      @doc_path = doc_path
    end

    def translation_requests
      doc = load_frontmatter

      I18n.available_locales.map do |locale|
        Translator::TranslationRequest.new(locale: locale, frequency: frequency(doc), path: doc_path)
      end
    end

    def load_frontmatter
      @load_frontmatter ||= YAML.safe_load(File.read("#{Rails.configuration.docs_base_path}/_documentation/en/#{doc_path}"))
    end

    def frequency(doc)
      return doc['translation_frequency'] if doc['translation_frequency']

      find_matching_product
    end

    def find_matching_product
      products = YAML.safe_load(File.open("#{Rails.configuration.docs_base_path}/config/products.yml"))

      product = products['products'].detect { |p| doc_path.starts_with? p['path'] }

      raise ArgumentError, 'Unable to match document with products list in config/products.yml' unless product

      product_translation_frequency(product)
    end

    def product_translation_frequency(product)
      raise ArgumentError, "Expected a 'translation_frequency' attribute for this product but none found" if product['translation_frequency'].nil?

      product['translation_frequency']
    end
  end
end
