module Translator
  class TranslatorCoordinator
    attr_accessor :paths

    def initialize(params = {})
      @paths = params.fetch(:paths)
    end

    def jobs
      @jobs ||= requests.group_by(&:frequency)
    end

    def requests
      @requests ||= paths.map { |path| Translator::FileTranslator.new(path).translation_requests }.flatten
    end
  end
end
