class LanguagesDropdown
  def self.filter_languages_for_dropdown(item_list)
    languages = Nexmo::Markdown::CodeLanguage.languages.reject { |l| l.key == 'dotnet' }
    available_languages = item_list.map(&:languages).flatten.uniq.map(&:downcase)

    languages.select { |l| available_languages.include? l.key }
  end
end
