module Translator
  class TranslatorCoordinator
    attr_accessor :paths

    def initialize(params = {})
      @paths = params.fetch(:paths)
    end

    def organize_jobs
      requests = create_requests
      @organize_jobs ||= requests.group_by(&:frequency)
    end

    def create_requests
      @create_requests ||= paths.map { |path| Translator::FileTranslator.new(path).translation_requests }.flatten
    end
  end
end
