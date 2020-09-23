module Translator
  class SmartlingCoordinator
    attr_accessor :jobs

    def initialize(params = {})
      @jobs = params.fetch(:jobs)
    end

    def coordinate_jobs
      job_ids = jobs.reduce({}) do |memo, (freq, requests)|
        job_id = create_job(freq, requests)
        batch_id = create_batch(job_id)
        memo.merge({ freq => {"job" => job_id, "batch" => batch_id}})
      end

      job_ids
    end

    def locales(requests)
      requests.map do |j|
        j.locale.to_s
      end.uniq
    end

    def due_date(frequency)
      Time.zone.now + frequency.days
    end

    def perform
      create_batch
      upload_files
      execute_batch
    end

    def create_job(frequency, requests)
      return "job-#{frequency}"
      Translator::Smartling::JobCreator.new(
        locales: locales(requests),
        due_date: due_date(frequency)
      ).create_job
    end

    def create_batch(job_id)
      return "batch-#{job_id}"
      Translator::Smartling::BatchCreator.new(jobId: job_id)
    end
  end
end
