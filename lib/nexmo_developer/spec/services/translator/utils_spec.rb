require 'rails_helper'

RSpec.describe Translator::Utils do
  # rubocop:disable Lint/ConstantDefinitionInBlock
  class Dummy
    include Translator::Utils
  end
  # rubocop:enable Lint/ConstantDefinitionInBlock

  describe '#file_uri' do
    subject { Dummy.new.file_uri(filename) }

    context 'docs' do
      let(:filename) { '_documentation/en/concepts/overview.md' }

      it 'strips the root and locale from the path' do
        expect(subject).to eq('concepts/overview.md')
      end
    end

    context 'use_cases' do
      let(:filename) { '_use_cases/en/add-a-call-whisper-to-an-inbound-call.md' }

      it 'strips the locale from the path' do
        expect(subject).to eq('_use_cases/add-a-call-whisper-to-an-inbound-call.md')
      end
    end

    context 'tutorials' do
      context 'config/tutorials' do
        let(:filename) { 'config/tutorials/en/app-to-phone.yml' }

        it 'strips the locale from the path' do
          expect(subject).to eq('config/tutorials/app-to-phone.yml')
        end
      end

      context 'tutorials' do
        let(:filename) { '_tutorials/en/buy-nexmo-number.md' }

        it 'strips the locale from the path' do
          expect(subject).to eq('_tutorials/buy-nexmo-number.md')
        end

        context 'nested tutorial' do
          let(:filename) { '_tutorials/en/client-sdk/android-shared/authenticate-alice/java.md' }

          it 'strips the locale from the path' do
            expect(subject).to eq('_tutorials/client-sdk/android-shared/authenticate-alice/java.md')
          end
        end
      end
    end
  end

  describe '#storage_folder' do
    let(:locale) { 'cn' }

    subject { Dummy.new.storage_folder(filename, locale) }

    context 'docs' do
      context 'specifying the complete path' do
        let(:filename) { '_documentation/en/concepts/guides/authentication.md' }

        it 'returns the path to the folder where the translation should be stored' do
          expect(subject).to eq("#{Rails.configuration.docs_base_path}/_documentation/cn/concepts/guides")
        end
      end

      context 'specifying the file_uri' do
        let(:filename) { 'concepts/guides/authentication.md' }

        it 'returns the path to the folder where the translation should be stored' do
          expect(subject).to eq("#{Rails.configuration.docs_base_path}/_documentation/cn/concepts/guides")
        end
      end
    end

    context 'use_cases' do
      let(:filename) { '_use_cases/add-a-call-whisper-to-an-inbound-call.md' }

      it 'returns the path to the folder where the translation should be stored' do
        expect(subject).to eq("#{Rails.configuration.docs_base_path}/_use_cases/cn")
      end
    end

    context 'tutorials' do
      context 'config/tutorials' do
        let(:filename) { 'config/tutorials/en/app-to-phone.yml' }

        it 'returns the path to the folder where the translation should be stored' do
          expect(subject).to eq("#{Rails.configuration.docs_base_path}/config/tutorials/cn")
        end

        context 'nested tutorial' do
          let(:filename) { 'config/tutorials/en/app-to-phone/java.yml' }

          it 'returns the path to the folder where the translation should be stored' do
            expect(subject).to eq("#{Rails.configuration.docs_base_path}/config/tutorials/cn/app-to-phone")
          end
        end
      end

      context 'tutorials' do
        let(:filename) { '_tutorials/en/buy-nexmo-number.md' }

        it 'returns the path to the folder where the translation should be stored' do
          expect(subject).to eq("#{Rails.configuration.docs_base_path}/_tutorials/cn")
        end

        context 'nested tutorials' do
          let(:filename) { '_tutorials/en/client-sdk/android-shared/authenticate-alice/java.md' }

          it 'returns the path to the folder where the translation should be stored' do
            expect(subject).to eq("#{Rails.configuration.docs_base_path}/_tutorials/cn/client-sdk/android-shared/authenticate-alice")
          end
        end
      end
    end

    context 'config files' do
      let(:filename) { 'config/locales/en.yml' }

      it 'returns the path to the folder where the translation should be stored' do
        expect(subject).to eq('config/locales')
      end
    end
  end
end
