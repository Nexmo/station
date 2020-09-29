module Translator
  module Smartling
    class ApiRequestsGenerator
      attr_accessor :action, :uri, :token, :body

      def initialize(params = {})
        @action = params.fetch(:action)
        @uri = URI(params.fetch(:uri))
        @token = params.fetch(:token, Translator::Smartling::TokenGenerator.token)
        @body = params.fetch(:body)
      end

      def create
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        req = Net::HTTP::Post.new(uri.path, {
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{token}",
        })
        req.body = body.to_json
        res = http.request(req)
        message = JSON.parse(res.body)
        status_code = res.code

        validate_success(message, status_code)
      end

      def upload
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true

        request = Net::HTTP::Post.new(uri)
        request['Authorization'] = "Bearer #{token}"

        form_data = [
          ['fileUri', body['fileUri']],
          ['fileType', body['fileType']],
          ['localeIdsToAuthorize[]', body['localeIdsToAuthorize[]']],
          ['file', body['file']],
        ]
        request.set_form form_data, 'multipart/form-data'
        res = https.request(request)
        message = JSON.parse(res.body)
        status_code = res.code

        validate_success(message, status_code)
      end

      def validate_success(message, status_code)
        success_codes = ['200', '202']
        raise ArgumentError, "#{status_code}: #{message['response']['errors'][0]['message']}" unless success_codes.include?(status_code)

        case action
        when 'job'
          message['response']['data']['translationJobUid']
        when 'batch'
          message['response']['data']['batchUid']
        when 'upload'
          status_code
        else
          raise ArgumentError, "Unrecognized 'action' parameter, expected either 'job' or 'batch'"
        end
      end
    end
  end
end
