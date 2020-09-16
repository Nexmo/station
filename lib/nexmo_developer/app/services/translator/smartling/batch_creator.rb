module Translator
  module Smartling
    class BatchCreator
      def initialize(params = {})
        @jobId = params.fetch(:jobId)
      end
    end
  end
end