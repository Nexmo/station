module Translator
  module Smartling
    module API
      class FilePaths
        include Base

        def initialize(project_id:, token:)
          @project_id   = project_id
          @token        = token
        end

        def build_request
          Net::HTTP::Get.new(uri, headers)
        end

        def headers
          { 'Authorization' => "Bearer #{@token}", 'Content-Type' => 'application/json' }
        end

        def uri
          @uri ||= begin
            uri = URI("https://api.smartling.com/files-api/v2/projects/#{@project_id}/files/list")
          end
        end

        def success?
          @response.code == '200'
        end

        def return_value
          @return_value ||= response_body['response']['data']['items'].map { |item| item['fileUri'] }
        end
      end
    end
  end
end
