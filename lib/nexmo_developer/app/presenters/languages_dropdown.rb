require 'byebug'
class LanguagesDropdown
  def self.filter_languages_for_dropdown(item_list)
    languages_mapped = []
    languages = Nexmo::Markdown::CodeLanguage.languages.reject { |l| l.key == 'dotnet' }

    languages.each do |l|
      item_list.each do |i|
        if i.languages.map(&:downcase).include?(l.label.downcase)
          languages_mapped << l
        end
      end
    end
    languages_mapped
  end
end