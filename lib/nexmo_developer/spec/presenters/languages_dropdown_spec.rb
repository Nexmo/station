require 'rails_helper'

RSpec.describe LanguagesDropdown do
  describe '#filter_languages_from_dropdown' do
    it 'returns only languages that are in the items list' do
      items_list = Nexmo::Markdown::UseCase.all

      languages = LanguagesDropdown.filter_languages_for_dropdown(items_list)

      expect languages[0].label.downcase == items_list[0].languages.join(' ').downcase
    end
  end
end