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
        http = Net::HTTP.new(batch_uri.host, batch_uri.port)
        http.use_ssl = true
        req = Net::HTTP::Post.new(batch_uri.path, {
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{Translator::Smartling::TokenGenerator.token}",
        })
        req.body = { 'translationJobUuid' => job_id }.to_json
        res = http.request(req)
        message = JSON.parse(res.body)
        status_code = res.code
        validate_batch_creation(message, status_code)
      end

      def validate_batch_creation(message, status_code)
        raise ArgumentError, "#{status_code}: #{message['response']['code']}" unless status_code == 200

        batch_uuid(message['data']['batchUuid'])
      end

      def batch_uuid(uuid)
        @batch_uuid ||= uuid
      end
    end
  end
end
