module Translator
  class FileTranslator
    attr_reader :doc_path

    def initialize(doc_path)
      @doc_path = doc_path
    end

    def translation_requests
      I18n.available_locales.map do |locale|
        Translator::TranslationRequest.new(locale: locale, frequency: frequency, path: doc_path)
      end
    end

    def frontmatter
      @frontmatter ||= YAML.safe_load(File.read("#{Rails.configuration.docs_base_path}/_documentation/en/#{doc_path}"))
    end

    def frequency
      return frontmatter['translation_frequency'] if frontmatter['translation_frequency']

      product_translation_frequency
    end

    def find_product
      products = YAML.safe_load(File.open("#{Rails.configuration.docs_base_path}/config/products.yml"))

      @product ||= products['products'].detect { |p| doc_path.starts_with? p['path'] }

      raise ArgumentError, 'Unable to match document with products list in config/products.yml' unless @product

      @product
    end

    def product_translation_frequency
      product = find_product

      raise ArgumentError, "Expected a 'translation_frequency' attribute for this product but none found" unless product['translation_frequency']

      product['translation_frequency']
    end
  end
end
