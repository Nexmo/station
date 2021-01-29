require 'rails_helper'

RSpec.describe Translator::Smartling::API::FileUris do
  let(:project_id) { 'smartling-project-id' }
  let(:uri) { "https://api.smartling.com/published-files-api/v2/projects/#{project_id}/files/list/recently-published" }
  let(:token) { 'smartling-auth-token' }

  before do
    allow_any_instance_of(Translator::Smartling::API::FileUris).to receive(:format_date).and_return('2020-10-16T18:27:20+00:00')
  end

  subject do
    described_class.new(
      project_id: project_id,
      token: token
    )
  end

  describe '#call' do
    context 'on success' do
      it 'returns an array with file uris of completed translations' do
        stub_request(:get, uri)
          .with(
            headers: { 'Authorization' => "Bearer #{token}", 'Content-Type' => 'application/json' },
            query: URI.encode_www_form('publishedAfter' => subject.format_date)
          )
          .to_return(
            status: 200,
            body: {
              response: {
                code: 'SUCCESS',
                data: {
                  items: [
                    {
                      created: '2017-09-06T20:29:15Z',
                      fileType: 'csv',
                      fileUri: '/files/translation_import.csv',
                      hasInstructions: false,
                      lastUploaded: '2017-09-06T20:29:15Z',
                    },
                    {
                      created: '2017-05-27T12:45:36Z',
                      fileType: 'javaProperties',
                      fileUri: '/files/4.properties',
                      hasInstructions: false,
                      lastUploaded: '2017-05-27T12:45:36Z',
                    },
                  ],
                  totalCount: 2,
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
            query: URI.encode_www_form('publishedAfter' => subject.format_date)
          )
          .to_return(
            status: 500,
            body: {
              response: {
                code: 'GENERAL_ERROR',
                errors: [
                  {
                    key: 'general_error',
                    message: 'Unexpected server error',
                    details: {},
                  },
                ],
              },
            }.to_json.to_s
          )

        expect(Bugsnag).to receive(:notify).with('Translator::Smartling::API::FileUris 500: Unexpected server error')
        expect(subject.call).to be_nil
      end
    end
  end
end
