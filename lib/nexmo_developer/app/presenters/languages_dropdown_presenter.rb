class LanguagesDropdownPresenter
  class Option
    def initialize(language)
      @language = language
    end

    def code_language
      @code_language ||= @language.key
    end
  end

  def initialize(scope)
    @scope = scope
  end

  def options
    @options ||= languages.select { |l| scoped_languages.include? l.key }.map { |l| Option.new(l) }
  end

  def scoped_languages
    @scoped_languages ||= @scope.map(&:languages).flatten.uniq.map(&:downcase)
  end

  def languages
    @languages ||= Nexmo::Markdown::CodeLanguage.languages.reject { |l| l.key == 'dotnet' }
  end
end
