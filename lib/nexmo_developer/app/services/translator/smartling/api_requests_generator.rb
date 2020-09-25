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

      def validate_success(message, status_code)
        success_codes = [200, 202]
        raise ArgumentError, "#{status_code}: #{message['response']['code']}" unless success_codes.include?(status_code)

        case action
        when 'job'
          uuid(message['data']['translationJobUuid'])
        when 'batch'
          uuid(message['data']['batchUuid'])
        when 'upload'
          message['response']['data']['message']
        else
          raise ArgumentError, "Unrecognized 'action' parameter, expected either 'job' or 'batch'"
        end
      end

      def uuid(uuid)
        uuid
      end
    end
  end
end
