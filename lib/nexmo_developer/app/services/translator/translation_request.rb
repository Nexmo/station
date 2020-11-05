module Translator
  class TranslationRequest
    attr_reader :locale, :frequency, :file_uri

    def initialize(locale:, frequency:, file_uri:)
      @locale    = locale
      @frequency = frequency
      @file_uri  = file_uri
    end
  end
end
