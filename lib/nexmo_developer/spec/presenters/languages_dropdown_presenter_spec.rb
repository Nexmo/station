require 'rails_helper'

RSpec.describe LanguagesDropdownPresenter do
  subject { described_class.new }
  let(:languages) do
    Nexmo::Markdown::CodeLanguage.languages.reject { |l| l.key == 'dotnet' }
  end

  describe '#options' do
    it 'returns only languages that are in config/code_languages.yml' do
      options = subject.options

      expect(options.size).to eq(languages.size)
      expect(options).to all(be_an_instance_of(described_class::Option))
      expect(options.map(&:code_language)).to match_array(languages.map(&:key))
    end
  end
end
