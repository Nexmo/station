module Translator
  class SmartlingCoordinator
    attr_accessor :jobs

    def initialize(params = {})
      @jobs = params.fetch(:jobs)

      validate!
    end

    def validate!
      raise ArgumentError, "Expected the 'jobs' parameter to be a Hash" if jobs.is_a?(String)
      raise ArgumentError, "Expected the value of the 'jobs' parameter to be an Array" unless jobs.values.all?(Array)
    end

    def coordinate_jobs
      result = jobs.reduce({}) do |memo, (freq, requests)|
        job_id = create_job(freq, requests)
        batch_id = create_batch(job_id)
        memo.reverse_merge!({ freq => { 'job_id' => job_id, 'batch_id' => batch_id, 'locales' => locales(requests), 'requests' => requests } })
      end

      result.each_value do |r|
        initiate_upload_to_batch(r)
      end
    end

    def locales(requests)
      requests.map do |j|
        j.locale.to_s
      end.uniq
    end

    def due_date(frequency)
      (Time.zone.now + frequency.days).to_s
    end

    def create_job(frequency, requests)
      Translator::Smartling::JobCreator.new(
        locales: locales(requests),
        due_date: due_date(frequency)
      ).create_job
    end

    def create_batch(job_id)
      Translator::Smartling::BatchCreator.new(jobId: job_id).create_batch
    end

    def initiate_upload_to_batch(jobs)
      Translator::Smartling::FileUpload.new(
        batch_id: jobs['batch_id'],
        locales: jobs['locales'],
        docs: jobs['requests']
      ).initiate_upload
    end
  end
end
