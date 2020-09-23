module Translator
  class TranslatorCoordinator
    attr_reader :paths

    def initialize(params = {})
      @paths = params.fetch(:paths)
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
