require 'rails_helper'

RSpec.describe Translator::FileTranslator do
  let(:doc_path) { '_documentation/en/voice/voice-api/guides/numbers.md' }

  subject { described_class.new(doc_path) }

  it 'accepts a documentation path to initialize an instance' do
    expect(subject.doc_path).to eql(doc_path)
  end

  describe '#frontmatter' do
    it 'loads the document metadata correctly' do
      expect(subject.frontmatter).to include('translation_frequency' => 13)
    end
  end

  describe '#translation_requests' do
    it 'returns an array of Translator::TranslationRequest instances' do
      requests = subject.translation_requests

      expect(requests).to all(be_a(Translator::TranslationRequest))
      expect(requests.map(&:locale).uniq).to match_array(['zh-CN', 'ja-JP'])
    end
  end

  describe '#frequency' do
    context 'doc' do
      it 'returns the translation frequency from the document if it exists' do
        expect(subject.frequency).to be(13)
      end

      context 'translation frequency not present in the doc' do
        let(:doc_path) { '_documentation/en/messaging/sms/overview.md' }

        it 'returns the translation frequency from the products config' do
          expect(subject.frequency).to be(15)
        end
      end

      context 'translation frequency cannot be found in either document or products config' do
        let(:doc_path) { '_documentation/en/vonage-business-cloud/vbc-apis/user-api/overview.md' }

        it 'raises an exception' do
          expect { subject.frequency }.to raise_error(ArgumentError, "Expected a 'translation_frequency' attribute for VBC User API but none found")
        end
      end
    end
  end

  describe '#product_translation_frequency' do
    context 'doc' do
      it 'finds the matching product translation frequency in the products config YAML file' do
        expect(subject.product_translation_frequency).to eql(15)
      end
    end

    context 'tutorial' do
      let(:doc_path) { '_tutorials/en/application/create-voice.md' }

      it { expect(subject.product_translation_frequency).to eq(15) }
    end
  end

  describe '#product' do
    context 'docs' do
      context 'with an associated product' do
        let(:doc_path) { '_documentation/en/messaging/sms/overview.md' }

        it 'returns the corresponding product' do
          expect(subject.product).to include('name' => 'SMS API', 'translation_frequency' => 15)
        end
      end

      context 'otherwise' do
        let(:doc_path) { '_documentation/en/warship/tiktok/overview.md' }

        it 'raises an exception if there isn\'t a product associated' do
          expect { subject.product }.to raise_error(ArgumentError, "Unable to match document with products list in config/products.yml for #{Rails.configuration.docs_base_path}/_documentation/en/warship/tiktok/overview.md")
        end
      end
    end

    context 'use_case' do
      let(:doc_path) { '_use_cases/en/dummy.md' }

      it 'returns the corresponding product' do
        expect(subject.product).to include({ 'translation_frequency' => 14, 'path' => 'number-insight' })
      end
    end

    context 'tutorial config' do
      let(:doc_path) { 'config/tutorials/en/two-factor-authentication-dotnet-verify-api.yml' }

      it 'returns the corresponding product' do
        expect(subject.product).to include({ 'translation_frequency' => 10, 'path' => 'verify' })
      end

      context 'product is not present in the frontmatter' do
        let(:doc_path) { 'config/tutorials/en/without-product.yml' }

        it 'raises' do
          expect { subject.product }.to raise_error(ArgumentError, "Unable to match document with products list in config/products.yml for #{Rails.configuration.docs_base_path}/config/tutorials/en/without-product.yml")
        end
      end
    end
  end

  describe '#full_path' do
    it 'returns a complete file path for the partial path provided' do
      expect(subject.full_path).to eql("#{Rails.configuration.docs_base_path}/#{doc_path}")
    end
  end
end
