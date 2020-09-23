module Translator
  class SmartlingCoordinator
    attr_accessor :jobs

    def initialize(params = {})
      @jobs = params.fetch(:jobs)
      byebug
    end

    def coordinate_job
      # {13 => [], 15 => []}
      # 13, 15
      # [], [], []
      jobs.each do |freq, requests|
        @new_job_request = {}
        @new_job_request[:due_date] = due_date(freq)
        @new_job_request[:locales] = 
        @new_job_request[:requests] = requests
      end
    end

    def locales
      @locales ||= begin
        jobs.each { |arr| arr[1].each { |job| @locales << job.locale.to_s } }
        @locales.uniq!
      end
    end

    def due_date(frequency)
      @due_date ||= (Time.zone.now + frequency.days)
    end

    def perform
      create_batch
      upload_files
      execute_batch
    end

    def create_job
      @create_job ||= Translator::Smartling::JobCreator.new(
        locales: locales,
        due_date: due_date
      ).create_job
    end

    def create_batch
      @create_batch ||= Translator::Smartling::BatchCreator.new(jobId: create_job)
    end
  end
end
