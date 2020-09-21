module Translator
  module Smartling
    class BatchCreator
      def initialize(params = {})
        @job_id = params.fetch(:jobId)
      end
    end
  end
end
