require 'rails_helper'

RSpec.describe Translator::Utils do
  subject { Translator::SmartlingDownloader.new(paths: ['_documentation/en/messaging/sms/overview.md']) }

  describe '#locale_without_region' do
    it 'returns a symbol for a locale string' do
      expect(subject.locale_without_region('zh-CN')).to eq(:cn)
    end

    it 'defaults to :en for locale' do
      expect(subject.locale_without_region('il-HE')).to eq(:en)
    end
  end

  describe '#storage_folder' do
    it 'returns a full i18n documentation folder path' do
      expect(subject.storage_folder('_documentation/en/messaging/sms/overview.md', 'en')).to eq("#{Rails.configuration.docs_base_path}/_documentation/en/messaging/sms")
    end

    it 'returns a folder path for locale config files' do
      expect(subject.storage_folder('config/locales/en.yml', 'en')).to eq('config/locales')
    end

    it 'raises an exception if folder input is not recognized' do
      expect { subject.storage_folder('not/recognized/invalid.yml', 'en') }.to raise_error('Unexpected file path')
    end
  end
end
