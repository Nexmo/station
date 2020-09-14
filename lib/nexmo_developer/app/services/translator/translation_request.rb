module Translator
  class TranslationRequest
    attr_accessor :locale, :frequency, :path

    def initialize(params = {})
      @locale = params.fetch(:locale)
      @frequency = params.fetch(:frequency)
      @path = params.fetch(:path)
    end
  end
end
