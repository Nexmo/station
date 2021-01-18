require 'rails_helper'

RSpec.describe Translator::Smartling::API::DownloadFile do
  let(:project_id) { 'smartling-project-id' }
  let(:uri) { "https://api.smartling.com/files-api/v2/projects/#{project_id}/locales/#{locale_id}/file" }
  let(:locale_id) { 'zh-CN' }
  let(:token) { 'smartling-auth-token' }
  let(:file_uri) { ['messages/external-accounts/overview.md'] }

  subject do
    described_class.new(
      project_id: project_id,
      locale_id: locale_id,
      file_uri: file_uri,
      token: token
    )
  end

  describe '#call' do
    context 'on success' do
      it 'returns the translated string' do
        stub_request(:get, uri)
          .with(
            headers: { 'Authorization' => "Bearer #{token}", 'Content-Type' => 'application/json' },
            query: URI.encode_www_form(
              'fileUri' => 'messages/external-accounts/overview.md',
              'retrievalType' => 'published'
            )
          )
          .to_return(status: 200, body: '翻译文字')

        expect(subject.call).to eq('翻译文字')
      end
    end

    context 'on failure' do
      it 'logs the API error message and returns nil' do
        stub_request(:get, uri)
          .with(
            headers: { 'Authorization' => "Bearer #{token}", 'Content-Type' => 'application/json' },
            query: URI.encode_www_form(
              'fileUri' => 'messages/external-accounts/overview.md',
              'retrievalType' => 'published'
            )
          )
          .to_return(
            status: 500,
            body: {
              "response": {
                "code": 'GENERAL_ERROR',
                "errors": [
                  {
                    "key": 'general_error',
                    "message": 'Unexpected server error',
                    "details": {},
                  },
                ],
              },
            }.to_json.to_s
          )

        expect(Bugsnag).to receive(:notify).with('Translator::Smartling::API::DownloadFile 500: Unexpected server error')
        expect(subject.call).to be_nil
      end
    end
  end
end
