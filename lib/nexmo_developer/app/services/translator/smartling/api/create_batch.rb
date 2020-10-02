module Translator
  module Smartling
    module API
      class CreateBatch
        include Base

        def initialize(project_id:, job_id:, token:)
          @project_id = project_id
          @job_id     = job_id
          @token      = token
        end

        def request_body
          { 'translationJobUid' => @job_id, 'authorize' => true }
        end

        def uri
          @uri ||= URI("https://api.smartling.com/jobs-batch-api/v1/projects/#{@project_id}/batches")
        end

        def success?
          @response.code == '200'
        end

        def return_value
          @return_value ||= response_body['response']['data']['batchUid']
        end

        def headers
          { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{@token}" }
        end
      end
    end
  end
end
