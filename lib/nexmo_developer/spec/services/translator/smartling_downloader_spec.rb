require 'rails_helper'

RSpec.describe Translator::SmartlingDownloader do
  let(:paths) { ['messaging/sms/overview.md', 'voice/voice-api/guides/numbers.md'] }

  subject { described_class.new(paths: paths) }

  describe '#call' do
    it 'gets a list of locales of translated files ready to download and downloads each file' do
      expect(subject).to receive(:get_file_status).exactly(2).times.and_return(['ja-JP', 'zh-CN'])
      expect(subject).to receive(:download_file).exactly(4).times

      subject.call
    end
  end

  describe '#get_file_status' do
    it 'gets the file status' do
      expect(Translator::Smartling::ApiRequestsGenerator).to receive(:get_file_status)
        .with(path: ['messaging/sms/overview.md'])

      subject.get_file_status(path: ['messaging/sms/overview.md'])
    end
  end

  describe '#download_file' do
    it 'downloads the translated file' do
      expect(Translator::Smartling::ApiRequestsGenerator).to receive(:download_file)
        .with(locale: 'ja-JP', path: ['messaging/sms/overview.md'])

      subject.download_file(locale: 'ja-JP', path: ['messaging/sms/overview.md'])
    end
  end
end
