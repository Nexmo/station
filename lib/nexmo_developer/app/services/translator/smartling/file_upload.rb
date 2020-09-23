module Translator
  module Smartling
    class FileUpload
      attr_accessor :jobs

      def initialize(params = {})
        @jobs = params.fetch(:jobs)
      end

      def upload_uri
        @upload_uri ||= URI("https://api.smartling.com/jobs-batch-api/v1/projects/#{ENV['SMARTLING_PROJECT_ID']}/batches/#{batch_id}/file")
      end

      def upload_files
        jobs.each do |_freq, job|
          job['requests'].each do |req|
            Translator::Smartling::ApiRequestsGenerator.new(
              action: 'upload',
              uri: upload_uri,
              body: {
                'file' => File.read("#{Rails.configuration.docs_base_path}/#{req.path}"),
                'fileUri' => req.path,
                'fileType' => 'markdown',
                'localeIdsToAuthorize[]' => locales,
              }
            ).create
          end
        end
      end
    end
  end
end
