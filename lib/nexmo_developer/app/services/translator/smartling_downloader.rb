module Translator
  class SmartlingDownloader
    include ::Translator::Utils

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
        path: file_path(path, 'en')
      )
    end

    def download_file(locale:, path:)
      doc = ::Translator::Smartling::ApiRequestsGenerator.download_file(
        locale: locale,
        path: file_path(path, 'en')
      )

      save_file(doc, locale, path)
    end

    def save_file(doc, locale, path)
      locale = locale_without_region(locale.to_s)
      folder = storage_folder(path, locale)
      FileUtils.mkdir_p(folder) unless File.exist?(folder)
      File.open(file_path(path, locale), 'w+') do |file|
        file.write(Nexmo::Markdown::Pipelines::Smartling::Download.call(doc))
      end
    end
  end
end
