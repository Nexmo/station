require 'smartling'

module Translator
  module Smartling
    class JobCreator
      attr_reader :job_name, :locales, :due_date, :user_id, :user_secret, :project_id

      def initialize(params = {})
        @job_name = "stationTranslationJob#{rand 10**10}"
        @locales = params.fetch(:locales)
        @due_date = params.fetch(:due_date)
        @user_id = ENV['SMARTLING_USER_ID']
        @user_secret = ENV['SMARTLING_USER_SECRET']
        @project_id = ENV['SMARTLING_PROJECT_ID']
      end

      def client
        @client ||= ::Smartling::Api.new(
          userId: user_id,
          userSecret: user_secret
        )
      end

      def token
        @token ||= client.token
      end

      def job_uri
        @job_uri ||= URI("https://api.smartling.com/jobs-api/v3/projects/#{project_id}/jobs")
      end

      def create_job
        http = Net::HTTP.new(job_uri.host, job_uri.port)
        http.use_ssl = true
        req = Net::HTTP::Post.new(job_uri.path, {
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{token}",
        })
        req.body = {
          'jobName' => "ADP Translation Job: #{Time.zone.now}",
          'targetLocaleIds' => locales,
          'dueDate' => due_date,
        }.to_json
        res = http.request(req)

        validate_job_creation(res)
      end

      def validate_job_creation(result)
        raise ArgumentError, "#{result.status}: #{result.code}" unless result.status == 200

        job_uuid(result.data)
      end

      def job_uuid(data)
        @job_uuid ||= data.translationJobUid
      end
    end
  end
end
