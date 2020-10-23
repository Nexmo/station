require 'rails_helper'

RSpec.describe Translator::Smartling::API::FilePaths do
  let(:project_id) { 'smartling-project-id' }
  let(:uri) { "https://api.smartling.com/published-files-api/v2/projects/#{project_id}/files/list/recently-published" }
  let(:token) { 'smartling-auth-token' }

  subject do
    described_class.new(
      project_id: project_id,
      token: token
    )
  end

  describe '#call' do
    context 'on success' do
      it 'returns an array with paths of completed translations' do
        stub_request(:get, uri)
          .with(
            headers: { 'Authorization' => "Bearer #{token}", 'Content-Type' => 'application/json' },
            query: URI.encode_www_form('publishedAfter' => '2020/10/16')
          )
          .to_return(
            status: 200,
            body: {
              "response": {
                "code": 'SUCCESS',
                "data": {
                  "items": [
                    {
                      "created": '2017-09-06T20:29:15Z',
                      "fileType": 'csv',
                      "fileUri": '/files/translation_import.csv',
                      "hasInstructions": false,
                      "lastUploaded": '2017-09-06T20:29:15Z',
                    },
                    {
                      "created": '2017-05-27T12:45:36Z',
                      "fileType": 'javaProperties',
                      "fileUri": '/files/4.properties',
                      "hasInstructions": false,
                      "lastUploaded": '2017-05-27T12:45:36Z',
                    },
                  ],
                  "totalCount": 2,
                },
              },
            }.to_json.to_s
          )

        expect(subject.call).to eq(['/files/translation_import.csv', '/files/4.properties'])
      end
    end

    context 'on failure' do
      it 'logs the API error message and returns nil' do
        stub_request(:get, uri)
          .with(
            headers: { 'Authorization' => "Bearer #{token}", 'Content-Type' => 'application/json' },
            query: URI.encode_www_form('publishedAfter' => '2020/10/16')
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

        expect(Bugsnag).to receive(:notify).with('Translator::Smartling::API::FilePaths 500: Unexpected server error')
        expect(subject.call).to be_nil
      end
    end
  end
end
