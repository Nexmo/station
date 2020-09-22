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
        raise ArgumentError, "#{status_code}: #{message['response']['code']}" unless status_code == 200

        case action
        when 'job'
          uuid(message['data']['translationJobUuid'])
        when 'batch'
          uuid(message['data']['batchUuid'])
        else
          raise ArgumentError, "Unrecognized 'action' parameter, expected either 'job' or 'batch'"
        end
      end

      def uuid(uuid)
        @uuid ||= uuid
      end
    end
  end
end
