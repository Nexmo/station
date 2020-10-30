require 'rails_helper'

RSpec.describe FeedbackPresenter do
  let(:params) { {} }
  let(:request) { double(parameters: { 'code_language' => 'ruby' }) }
  let(:session) { {} }
  let(:document_path) { nil }

  subject { described_class.new(params, request, session, document_path) }

  describe '#code_language?' do
    context 'when `code_language` params is present' do
      let(:params) { { code_language: 'ruby' } }

      it 'returns true' do
        expect(subject.code_language?).to eq(true)
      end
    end

    it 'returns false otherwise' do
      expect(subject.code_language?).to eq(false)
    end
  end

  describe '#code_language' do
    it 'returns the code language set in the request' do
      expect(subject.code_language).to eq('ruby')
    end
  end

  describe '#captcha_enabled?' do
    it 'returns true if the env variable is set' do
      expect(ENV).to receive(:[]).with('RECAPTCHA_ENABLED').and_return(true)
      expect(subject.captcha_enabled?).to eq(true)
    end

    it { expect(subject.captcha_enabled?).to eq(false) }
  end

  describe '#captcha_key' do
    it 'returns the key if present' do
      expect(ENV).to receive(:[]).with('RECAPTCHA_INVISIBLE_SITE_KEY').and_return('abc123')
      expect(subject.captcha_key).to eq('abc123')
    end

    it { expect(subject.captcha_key).to be_nil }
  end

  describe '#passed_invisible_captcha?' do
    context 'when the value is set in the session' do
      let(:session) { { user_passed_invisible_captcha: true } }

      it 'returns the value' do
        expect(subject.passed_invisible_captcha?).to eq(true)
      end
    end

    it 'returns false otherwise' do
      expect(subject.passed_invisible_captcha?).to eq(false)
    end
  end

  describe '#show_github_link?' do
    context 'with a document_path' do
      let(:document_path) { 'dummy/doc' }

      it { expect(subject.show_github_link?).to eq(true) }
    end

    it { expect(subject.show_github_link?).to eq(false) }
  end

  describe '#github_url' do
    let(:document_path) { "#{Rails.configuration.docs_base_path}/_documentation/en/concepts/overview.md" }

    it 'returns the url to the doc' do
      expect(subject.github_url).to eq("https://github.com/nexmo/nexmo-docs/blob/master/#{document_path.gsub("#{Rails.configuration.docs_base_path}/", '')}")
    end
  end
end
