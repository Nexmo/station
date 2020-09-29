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
        @upload_uri ||= URI("https://api.smartling.com/jobs-batch-api/v2/projects/#{ENV['SMARTLING_PROJECT_ID']}/batches/#{batch_id}/file")
      end

      def initiate_upload
        result = []
        docs.each do |doc|
          result << upload_file(doc)
        end
      end

      def upload_file(doc)
        Translator::Smartling::ApiRequestsGenerator.new(
          action: 'upload',
          uri: upload_uri,
          body: {
            'file' => File.open("#{Rails.configuration.docs_base_path}/_documentation/#{I18n.default_locale}/#{doc.path}"),
            'fileUri' => doc.path,
            'fileType' => 'markdown',
            'localeIdsToAuthorize[]' => locales,
          }
        ).upload
      end
    end
  end
end
