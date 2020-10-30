require 'rails_helper'

RSpec.describe Translator::Smartling::API::FileStatus do
  let(:project_id) { 'smartling-project-id' }
  let(:uri) { "https://api.smartling.com/files-api/v2/projects/#{project_id}/file/status" }
  let(:token) { 'smartling-auth-token' }
  let(:file_uri) { ['messages/external-accounts/overview.md'] }

  subject do
    described_class.new(
      project_id: project_id,
      file_uri: file_uri,
      token: token
    )
  end

  describe '#call' do
    context 'on success' do
      it 'returns an array with translated locales' do
        stub_request(:get, uri)
          .with(
            headers: { 'Authorization' => "Bearer #{token}", 'Content-Type' => 'application/json' },
            query: URI.encode_www_form('fileUri' => 'messages/external-accounts/overview.md')
          )
          .to_return(
            status: 200,
            body: {
              "response": {
                "code": 'SUCCESS',
                "data": {
                  "created": '2017-09-06T20:29:15Z',
                  "directives": {
                    "file_uri_as_namespace": 'true',
                  },
                  "fileType": 'markdown',
                  "fileUri": '/messages/external-accounts/overview.md',
                  "hasInstructions": false,
                  "items": [
                    {
                      "authorizedStringCount": 0,
                      "authorizedWordCount": 0,
                      "completedStringCount": 0,
                      "completedWordCount": 0,
                      "excludedStringCount": 0,
                      "excludedWordCount": 0,
                      "localeId": 'zh-CN',
                    },
                  ],
                  "lastUploaded": '2017-09-06T20:29:15Z',
                  "namespace": {
                  "name": '/messages/external-accounts/overview.md',
                },
                  "parserVersion": 4,
                  "totalCount": 1,
                  "totalStringCount": 1,
                  "totalWordCount": 1,
                },
              },
            }.to_json.to_s
          )

        expect(subject.call).to eq(['zh-CN'])
      end
    end

    context 'on failure' do
      it 'logs the API error message and returns nil' do
        stub_request(:get, uri)
          .with(
            headers: { 'Authorization' => "Bearer #{token}", 'Content-Type' => 'application/json' },
            query: URI.encode_www_form('fileUri' => 'messages/external-accounts/overview.md')
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

        expect(Bugsnag).to receive(:notify).with('Translator::Smartling::API::FileStatus 500: Unexpected server error')
        expect(subject.call).to be_nil
      end
    end
  end
end
