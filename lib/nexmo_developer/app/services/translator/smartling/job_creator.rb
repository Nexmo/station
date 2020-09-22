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
        Translator::Smartling::ApiRequestsGenerator.new(
          action: 'job',
          uri: job_uri,
          body: {
            'jobName' => "ADP Translation Job: #{Time.zone.now}",
            'targetLocaleIds' => locales,
            'dueDate' => due_date,
          }
        ).create
      end
    end
  end
end
