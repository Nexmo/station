require 'rails_helper'

RSpec.describe LanguagesDropdownPresenter do
  let(:scope) { Nexmo::Markdown::UseCase.all }

  subject { described_class.new(scope) }

  describe '#options' do
    it 'returns only languages that are in the items list' do
      options = subject.options

      expect(options.size).to eq(3)
      expect(options).to all(be_an_instance_of(described_class::Option))
      expect(options.map(&:code_language)).to match_array(['node', 'kotlin', 'ruby'])
    end
  end
end
