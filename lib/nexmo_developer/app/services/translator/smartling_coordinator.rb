module Translator
  class SmartlingCoordinator
    attr_accessor :jobs

    def initialize(params = {})
      @jobs = params.fetch(:jobs)
    end

    def locales
      @locales ||= jobs.each { |job| @locales << job.locale.to_s }
    end

    def due_date(frequency)
      @due_date ||= (Time.zone.now + frequency.days)
    end

    def perform
      create_job
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
