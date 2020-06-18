require 'rails_helper'

RSpec.describe LanguagesDropdown do
  describe '#filter_languages_from_dropdown' do
    it 'returns only languages that are in the items list' do
      items_list = Nexmo::Markdown::UseCase.all

      languages = LanguagesDropdown.filter_languages_for_dropdown(items_list)

      expect(languages.map(&:key)).to eq(items_list.map(&:languages).flatten.map(&:downcase))
    end
  end
end
