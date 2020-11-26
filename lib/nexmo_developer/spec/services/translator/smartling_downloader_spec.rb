require 'rails_helper'

RSpec.describe Translator::SmartlingDownloader do
  let(:file_uris) { ['messaging/sms/overview.md', 'voice/voice-api/guides/numbers.md'] }
  let(:token) { 'smartling-auth-token' }

  subject { described_class.new(file_uris: file_uris) }

  describe '#call' do
    context 'with file URIs provided in initialization' do
      it 'gets a list of locales of translated files ready to download and downloads each file' do
        expect(subject).to receive(:get_file_status).exactly(2).times.and_return(['ja-JP', 'zh-CN'])
        expect(subject).to receive(:download_file).exactly(4).times

        subject.call
      end

      it 'does something when no files are ready to download' do
        expect(subject).to receive(:get_file_status).exactly(2).times.and_return([])

        subject.call
      end
    end

    context 'without file URIs provided in initialization' do
      it 'makes a GET request to Smartling to obtain file URI paths of files ready to download' do
        expect(Translator::Smartling::ApiRequestsGenerator).to receive(:file_uris)
          .and_return(['/files/translation_import.csv', '/files/4.properties'])

        downloader = described_class.new

        expect(downloader.file_uris).to eql(['/files/translation_import.csv', '/files/4.properties'])
      end
    end
  end

  describe '#get_file_status' do
    it 'gets the file status' do
      expect(Translator::Smartling::ApiRequestsGenerator).to receive(:get_file_status)
        .with(file_uri: 'messaging/sms/overview.md')

      subject.get_file_status(file_uri: 'messaging/sms/overview.md')
    end
  end

  describe '#download_file' do
    it 'downloads the translated file' do
      expect(Translator::Smartling::ApiRequestsGenerator).to receive(:download_file)
        .with(locale: 'zh-CN', file_uri: 'messaging/sms/overview.md')
        .and_return(File.read("#{Rails.configuration.docs_base_path}/_documentation/cn/messaging/sms/overview.md"))
      expect(subject).to receive(:save_file)

      subject.download_file(locale: 'zh-CN', file_uri: 'messaging/sms/overview.md')
    end

    it 'does not download anything if there is no file returned by the API' do
      expect(Translator::Smartling::ApiRequestsGenerator).to receive(:download_file)
        .with(locale: 'zh-CN', file_uri: 'messaging/sms/overview.md')
        .and_return(nil)

      subject.download_file(locale: 'zh-CN', file_uri: 'messaging/sms/overview.md')
    end
  end

  describe '#save_file' do
    let(:doc) { 'binary file downloaded from Smartling' }
    let(:locale) { 'zh-CN' }
    let(:file_uri) { 'messaging/sms/overview.md' }
    let(:output_path) { "#{Rails.configuration.docs_base_path}/_documentation/cn/messaging/sms/overview.md" }
    let(:processed_doc) { File.read("#{Rails.configuration.docs_base_path}/_documentation/cn/messaging/sms/overview.md") }

    it 'stores the downloaded file to disk' do
      allow(File).to receive(:open).and_call_original
      allow(File).to receive(:write).and_call_original

      expect(Nexmo::Markdown::Pipelines::Smartling::Download).to receive(:call).with(doc).and_return(processed_doc)
      file_double = double(File)
      expect(file_double).to receive(:binmode)
      expect(File).to receive(:open).with(output_path, 'w+').and_yield(file_double)
      expect(file_double).to receive(:write).with(processed_doc)

      subject.save_file(doc, locale, file_uri)
    end
  end
end
