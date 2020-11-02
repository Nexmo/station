require 'rails_helper'

RSpec.describe FeedbackPresenter do
  let(:canonical_url) { 'https://developer.nexmo.com' }
  let(:feedback) { YAML.safe_load(File.read("#{Rails.configuration.docs_base_path}/config/feedback.yml")) }
  let(:params) { { code_language: 'ruby' } }

  subject { described_class.new(canonical_url, params) }

  describe '#props' do
    it 'returns a json object that acts as props for the vue component' do
      expect(subject.props['source']).to eq(canonical_url)
      expect(subject.props['configId']).to eq(Feedback::Config.last.id)
      expect(subject.props['title']).to eq(feedback['title'])
      expect(subject.props['paths']).to eq(feedback['paths'])
      expect(subject.props['codeLanguage']).to eq('ruby')
      expect(subject.props['codeLanguageSetByUrl']).to eq(true)
    end
  end

  describe '#show_feedback?' do
    context 'when the config file exists' do
      it { expect(subject.show_feedback?).to eq(true) }
    end

    context 'otherwise' do
      before do
        allow(File).to receive(:exist?).and_call_original
        allow(File).to receive(:exist?).and_return(false)
      end

      it { expect(subject.show_feedback?).to eq(false) }
    end
  end
end
