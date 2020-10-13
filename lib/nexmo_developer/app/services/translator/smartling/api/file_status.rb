module Translator
  module Smartling
    module API
      class FileStatus
        include Base

        def initialize(project_id:, path:, token:)
          @project_id   = project_id
          @path         = path
          @token        = token
        end

        def build_request
          Net::HTTP :Get.new(uri.path, headers)
        end

        def uri
          @uri ||= begin
            uri = URI("https://api.smartling.com/files-api/v2/projects/#{@project_id}/file/status")
            uri.query = URI.encode_www_form({ 'fileUri' => path })
            uri
          end
        end

        def success?
          @response.code == '200'
        end

        def return_value
          @return_value ||= response_body['data']['items'].map { |item| item['localeId'] }
        end
      end
    end
  end
end
