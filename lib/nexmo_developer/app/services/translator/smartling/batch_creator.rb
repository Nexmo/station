module Translator
  module Smartling
    class BatchCreator
      attr_reader :job_id, :project_id

      def initialize(params = {})
        @job_id = params.fetch(:jobId)
        @project_id = ENV['SMARTLING_PROJECT_ID']
      end

      def batch_uri
        @batch_uri ||= URI("https://api.smartling.com/jobs-batch-api/v1/projects/#{project_id}/batches")
      end

      def create_batch
        Translator::Smartling::ApiRequestsGenerator.new(
          action: 'batch',
          uri: batch_uri,
          body: { 'translationJobUid' => job_id, 'authorize' => true }
        ).create
      end
    end
  end
end
