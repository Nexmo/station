require 'rails_helper'

RSpec.describe Translator::FilesListCoordinator do
  let(:days) { 30 }

  subject { described_class.new(days: days) }

  describe '#process_doc_file' do
    it 'returns the file when its in the allowed products list' do
      expect(subject.process_doc_file('_documentation/en/voice/voice-api/guides/websockets.md')).to eql('_documentation/en/voice/voice-api/guides/websockets.md')
    end

    it 'returns an empty string when it is not in the allowed products list' do
      expect(subject.process_doc_file('_documentation/en/not-a-ga-product/guides/not-here.md')).to eql('')
    end
  end

  describe '#process_use_case_file' do
    context 'with a product in the allowed products list' do
      before { allow(subject).to receive(:use_case_product) { 'messaging/sms' } }

      it 'returns the file when it is in the allowed products list' do
        expect(subject.process_use_case_file('_use_cases/en/sms-customer-support.md')).to eql('_use_cases/en/sms-customer-support.md')
      end
    end

    context 'with a product not in the allowed products list' do
      before { allow(subject).to receive(:use_case_product) { 'martian/radar' } }

      it 'returns an empty string' do  
        expect(subject.process_use_case_file('_use_cases/en/not-a-ga-product/guides/not-here.md')).to eql('')
      end
    end
  end

  describe '#process_tutorial_file' do
    it 'does something' do
      subject.process_tutorial_file('_tutorials/en/voice/voice-api/call-a-websocket/conclusion.md')
    end
  end
end