require 'rails_helper'

RSpec.describe ProductDropdownPresenter do
  let(:scope) do
    [double(products: ['audit', 'verify']), double(products: ['audit', 'client-sdk'])]
  end

  subject { described_class.new(scope) }

  describe '#options' do
    it 'returns the products scoped to what is selected' do
      options = subject.options

      expect(options.size).to eq(3)
      expect(options).to all(be_an_instance_of(described_class::Option))
      expect(options.map(&:name)).to match_array(['Audit', 'Verify', 'Client SDK'])
    end
  end
end
