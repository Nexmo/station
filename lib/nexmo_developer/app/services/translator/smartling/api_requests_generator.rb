module Translator
  module Smartling
    class ApiRequestsGenerator
      def self.create_job(locales:, due_date:)
        ::Translator::Smartling::API::CreateJob.call(
          locales: locales,
          due_date: due_date,
          project_id: project_id,
          token: token
        )
      end

      def self.create_batch(job_id:, requests:)
        ::Translator::Smartling::API::CreateBatch.call(
          project_id: project_id,
          job_id: job_id,
          token: token,
          requests: requests
        )
      end

      def self.upload_file(batch_id:, translation_request:)
        ::Translator::Smartling::API::UploadFile.call(
          project_id: project_id,
          batch_id: batch_id,
          token: token,
          translation_request: translation_request
        )
      end

      def self.get_file_paths
        ::Translator::Smartling::API::FilePaths.call(
          project_id: project_id,
          token: token
        )
      end

      def self.get_file_status(path:)
        ::Translator::Smartling::API::FileStatus.call(
          project_id: project_id,
          token: token,
          path: path
        )
      end

      def self.download_file(locale:, path:)
        ::Translator::Smartling::API::DownloadFile.call(
          project_id: project_id,
          token: token,
          locale_id: locale,
          path: path
        )
      end

      def self.token
        @token ||= Translator::Smartling::TokenGenerator.token
      end

      def self.project_id
        @project_id ||= ENV['SMARTLING_PROJECT_ID']
      end
    end
  end
end
