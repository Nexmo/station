class SearchTerms
  def self.generate(locale = I18n.default_locale)
    document_paths = {
      documentation: {
        documents: Dir.glob("#{ENV['DOCS_BASE_PATH']}/_documentation/#{locale}/**/*.md"),
        origin: Pathname.new("#{ENV['DOCS_BASE_PATH']}/_documentation/#{locale}"),
        base_url_path: '',
      },
      api: {
        documents: Dir.glob("#{ENV['DOCS_BASE_PATH']}/_api/**/*.md"),
        origin: Pathname.new("#{ENV['DOCS_BASE_PATH']}/_api"),
        base_url_path: '/api',
      },
      use_cases: {
        documents: Dir.glob("#{ENV['DOCS_BASE_PATH']}/_use_cases/#{locale}/**/*.md"),
        origin: Pathname.new("#{ENV['DOCS_BASE_PATH']}/_use_cases/#{locale}"),
        base_url_path: '/use-cases',
      },
    }

    document_paths.map do |document_class, config|
      config[:documents].map do |document_path|
        Search::Document.new(document_class, config, document_path).articles.map(&:to_h)
      end
    end.flatten
  end
end
