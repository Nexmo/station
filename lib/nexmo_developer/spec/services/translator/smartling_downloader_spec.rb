require 'rails_helper'

RSpec.describe Translator::SmartlingDownloader do
  let(:file_uris) { ['_documentation/en/messaging/sms/overview.md', '_documentation/en/voice/voice-api/guides/numbers.md'] }
  let(:token) { 'smartling-auth-token' }

  subject { described_class.new(file_uris: file_uris) }

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
        .with(file_uri: '_documentation/en/messaging/sms/overview.md')

      subject.get_file_status(file_uri: '_documentation/en/messaging/sms/overview.md')
    end
  end

  describe '#download_file' do
    it 'downloads the translated file' do
      expect(Translator::Smartling::ApiRequestsGenerator).to receive(:download_file)
        .with(locale: 'zh-CN', file_uri: '_documentation/en/messaging/sms/overview.md')
        .and_return(File.read("#{Rails.configuration.docs_base_path}/_documentation/cn/messaging/sms/overview.md"))

      subject.download_file(locale: 'zh-CN', file_uri: '_documentation/en/messaging/sms/overview.md')
    end
  end
end
