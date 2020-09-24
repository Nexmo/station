module Translator
  module Smartling
    class FileUpload
      attr_accessor :batch_id, :locales, :docs

      def initialize(params = {})
        @batch_id = params.fetch(:batch_id)
        @locales = params.fetch(:locales)
        @docs = params.fetch(:docs)
      end

      def upload_uri
        @upload_uri ||= URI("https://api.smartling.com/jobs-batch-api/v1/projects/#{ENV['SMARTLING_PROJECT_ID']}/batches/#{batch_id}/file")
      end

      def upload_files
        docs.each do |doc|
          Translator::Smartling::ApiRequestsGenerator.new(
            action: 'upload',
            uri: upload_uri,
            body: {
              'file' => File.read("#{Rails.configuration.docs_base_path}/_documentation/#{I18n.default_locale}/#{doc.path}"),
              'fileUri' => doc.path,
              'fileType' => 'markdown',
              'localeIdsToAuthorize[]' => locales,
            }
          ).create
        end
      end
    end
  end
end
