require 'rails_helper'

RSpec.describe Translator::TranslatorCoordinator do
  let(:paths) { ['voice/voice-api/guides/numbers.md', 'messages/external-accounts/overview.md'] }
  subject { described_class.new(paths: paths) }

  it 'accepts an array of docs paths for initialization' do
    expect(subject.paths).to be_an(Array)
  end

  context '#after_initialize!' do
    describe 'with incorrect parameter object type' do
      it 'raises an exception' do
        expect { described_class.new(paths: 'this is not correct') }.to raise_error(ArgumentError, "Expected 'paths' parameter to be an Array")
      end
    end

    describe 'with incorrect parameter value object types' do
      it 'raises an exception' do
        expect { described_class.new(paths: [123, true, 'voice/voice-api-guides/numbers.md']) }.to raise_error(ArgumentError, "Expected all values in 'paths' parameter to be a String")
      end
    end

    describe 'with correct paths parameter' do
      it 'returns all the documentation requests in the jobs attribute as instances of the SmartlingCoordinator' do
        expect(subject.jobs).to be_a_kind_of(Translator::SmartlingCoordinator)
      end

      it 'has the documentation requests ordered by frequency in ascending order' do
        expect(subject.jobs.jobs.keys).to eql(subject.jobs.jobs.keys.sort)
      end

      it 'organizes the jobs value to be a Hash with the translation frequency as the key' do
        expect(subject.jobs.jobs.keys).to eql([13, 15])
      end

      it 'contains the documentation as an array of TranslationRequest instances for each translation frequency Hash key' do
        expect(subject.jobs.jobs.values[0]).to all(be_an_instance_of(Translator::TranslationRequest))
      end
    end
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
