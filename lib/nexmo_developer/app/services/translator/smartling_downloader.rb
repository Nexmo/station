module Translator
  class SmartlingDownloader
    attr_reader :paths

    def initialize(paths:)
      @paths = paths
    end

    def call
      @paths.map do |path|
        locales = get_file_status(path: path)
        locales.map { |locale| download_file(locale: locale, path: path) }
      end
    end

    def get_file_status(path:)
      ::Translator::Smartling::ApiRequestsGenerator.get_file_status(
        path: path
      )
    end

    def download_file(locale:, path:)
      ::Translator::Smartling::ApiRequestsGenerator.download_file(
        locale: locale,
        path: path
      )
    end
  end
end
