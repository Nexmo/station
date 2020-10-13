module Translator
  module Smartling
    module API
      class DownloadFile
        include Base

        def initialize(project_id:, locale_id:, path:, token:)
          @project_id   = project_id
          @locale_id    = locale_id
          @path         = path
          @token        = token
        end

        def build_request
          Net::HTTP :Get.new(uri.path, headers)
        end

        def uri
          @uri ||= begin
            uri = URI("https://api.smartling.com/files-api/v2/projects/#{@project_id}/locales/#{@locale_id}/file")
            uri.query = URI.encode_www_form({ 'fileUri' => path, 'retrievalType' => 'published' })
            uri
          end
        end

        def success?
          @response.code == '200'
        end

        def return_value
          @return_value ||= response_body
        end
      end
    end
  end
end
