module Translator
  class TranslationRequest
    attr_reader :locale, :frequency, :path

    def initialize(locale:, frequency:, path:)
      @locale    = locale
      @frequency = frequency
      @path      = path
    end
  end
end
