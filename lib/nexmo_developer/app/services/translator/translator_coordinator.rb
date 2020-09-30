module Translator
  class TranslatorCoordinator
    attr_reader :paths

    def initialize(params = {})
      @paths = params.fetch(:paths)

      after_initialize!
    end

    def after_initialize!
      raise ArgumentError, "Expected 'paths' parameter to be an Array" unless paths.is_a?(Array)
      raise ArgumentError, "Expected all values in 'paths' parameter to be a String" unless paths.all?(String)

      jobs
    end

    def jobs
      @jobs ||= requests.group_by(&:frequency)
      Translator::SmartlingCoordinator.new(jobs: @jobs)
    end

    def requests
      @requests ||= paths.map { |path| Translator::FileTranslator.new(path).translation_requests }.flatten
    end
  end
end
