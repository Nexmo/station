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

      def job_uri
        @job_uri ||= URI("https://api.smartling.com/jobs-api/v3/projects/#{project_id}/jobs")
      end

      def create_job
        http = Net::HTTP.new(job_uri.host, job_uri.port)
        http.use_ssl = true
        req = Net::HTTP::Post.new(job_uri.path, {
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{Translator::Smartling::TokenGenerator.token}",
        })
        req.body = {
          'jobName' => "ADP Translation Job: #{Time.zone.now}",
          'targetLocaleIds' => locales,
          'dueDate' => due_date,
        }.to_json
        res = http.request(req)
        message = JSON.parse(res.body)
        status_code = res.code
        validate_job_creation(message, status_code)
      end

      def validate_job_creation(message, status_code)
        raise ArgumentError, "#{status_code}: #{message['response']['code']}" unless status_code == 200

        job_uuid(message['data']['translationJobUuid'])
      end

      def job_uuid(uuid)
        @job_uuid ||= uuid
      end
    end
  end
end
