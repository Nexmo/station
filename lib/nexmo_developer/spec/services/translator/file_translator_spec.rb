require 'rails_helper'

RSpec.describe Translator::FileTranslator do
  let(:doc_path) { 'voice/voice-api/guides/numbers.md' }
  subject { described_class.new(doc_path) }

  it 'accepts a documentation path to initialize an instance' do
    expect(subject.doc_path).to eql(doc_path)
  end

  describe '#load_frontmatter' do
    it 'loads the document metadata correctly' do
      expect(subject.load_frontmatter).to include('translation_frequency' => 10)
    end
  end

  describe '#translation_requests' do
    it 'returns an array of Translator::TranslationRequest instances' do
      requests = subject.translation_requests

      expect(requests).to all(be_a(Translator::TranslationRequest))
    end
  end

  describe '#find_matching_product' do
    it 'finds the matching product translation frequency in the products config YAML file' do
      product = subject.find_matching_product

      expect(product).to eql(15)
    end
  end

  describe '#find_matching_product with no matching product' do
    let(:doc_path) { 'messaging/tiktok/overview.md' }
    subject { described_class.new(doc_path) }

    it 'raises an exception' do
      expect { subject.find_matching_product }.to raise_error(ArgumentError, 'Unable to match document with products list in config/products.yml')
    end
  end
end
