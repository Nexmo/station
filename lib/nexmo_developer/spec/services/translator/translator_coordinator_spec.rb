require 'rails_helper'

RSpec.describe Translator::TranslatorCoordinator do
  let(:paths) { ['voice/voice-api/guides/numbers.md', 'messages/external-accounts/overview.md'] }
  subject { described_class.new(paths: paths) }

  it 'accepts an array of docs paths for initialization' do
    expect(subject.paths).to be_an(Array)
  end

  describe '#requests' do
    it 'returns an Array of Translator::TranslationRequests instances' do
      expect(subject.requests).to all(be_a(Translator::TranslationRequest))
    end
  end

  describe '#jobs' do
    it 'returns the requests grouped by translation frequency in ascending order' do
      expect(subject.jobs.jobs.keys).to eql(subject.jobs.jobs.keys.sort)
    end
  end
end
