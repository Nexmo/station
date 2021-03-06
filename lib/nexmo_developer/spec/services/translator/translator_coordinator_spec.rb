require 'rails_helper'

RSpec.describe Translator::TranslatorCoordinator do
  let(:paths) { ['_documentation/en/voice/voice-api/guides/numbers.md', '_documentation/en/messages/external-accounts/overview.md'] }
  let(:frequency) { 15 }

  subject { described_class.new(paths: paths, frequency: frequency) }

  it 'accepts an array of docs paths for initialization' do
    expect(subject.paths).to be_an(Array)
  end

  describe '#requests' do
    it 'returns an Array of Translator::TranslationRequests instances' do
      expect(subject.requests).to all(be_a(Translator::TranslationRequest))
    end
  end

  describe '#create_smartling_jobs!' do
    it 'creates Jobs in Smartling for files with the provided frequency' do
      expect(Translator::SmartlingCoordinator).to receive(:call)

      subject.create_smartling_jobs!
    end
  end

  describe '#download_smartling_files!' do
    it 'starts the process for downloading files from Smartling' do
      expect(Translator::SmartlingDownloader).to receive(:call)

      subject.download_smartling_files!
    end
  end
end
