module Translator
  class FileTranslator
    attr_reader :doc_path

    def initialize(doc_path)
      @doc_path = doc_path
    end

    def translation_requests
      @translation_requests ||= begin
        I18n.available_locales.reject { |l| l.to_s == I18n.default_locale.to_s }.map do |locale|
          Translator::TranslationRequest.new(
            locale: locale_with_region(locale),
            frequency: frequency,
            path: doc_path,
          )
        end
      end
    end

    def frontmatter
      @frontmatter ||= YAML.safe_load(File.read(full_path))
    end

    def full_path
      @full_path ||= "#{Rails.configuration.docs_base_path}/_documentation/en/#{doc_path}"
    end

    def frequency
      @frequency ||= frontmatter['translation_frequency'] || product_translation_frequency
    end

    def locale_with_region(locale)
      case locale.to_s
      when 'ja', 'ja-JP'
        'ja-JP'
      when 'cn', 'zh-CN'
        'zh-CN'
      else
        locale.to_s
      end
    end

    def product
      @product ||= begin
        products = YAML.safe_load(File.open("#{Rails.configuration.docs_base_path}/config/products.yml"))
        product = products['products'].detect { |p| doc_path.starts_with? p['path'] }

        raise ArgumentError, 'Unable to match document with products list in config/products.yml' unless product

        product
      end
    end

    def product_translation_frequency
      raise ArgumentError, "Expected a 'translation_frequency' attribute for #{product['name']} but none found" unless product['translation_frequency']

      product['translation_frequency']
    end
  end
end
