require 'rails_helper'

RSpec.describe Translator::Smartling::API::UploadFile do
  let(:project_id) { 'smartling-project-id' }
  let(:uri) { "https://api.smartling.com/jobs-batch-api/v2/projects/#{project_id}/batches/#{batch_id}/file" }
  let(:token) { 'smartling-auth-token' }
  let(:batch_id) { 'smartling-batch-id' }
  let(:translation_request) do
    Translator::TranslationRequest.new(
      locale: 'ja-JP',
      frequency: 15,
      file_uri: 'messages/external-accounts/overview.md',
      file_path: "#{Rails.configuration.docs_base_path}/_documentation/en/messages/external-accounts/overview.md"
    )
  end

  subject do
    described_class.new(
      project_id: project_id,
      batch_id: batch_id,
      translation_request: translation_request,
      token: token
    )
  end

  describe '#form_data' do
    let(:file) { Tempfile.new }
    let(:request_body) do
      [
        ['file', File.open(file)],
        ['fileUri', translation_request.file_uri],
        ['fileType', 'markdown'],
        ['localeIdsToAuthorize[]', translation_request.locale],
      ]
    end

    it 'sets the right data for the request' do
      allow(File).to receive(:open).and_call_original
      allow(File).to receive(:open).and_return(file)

      expect(subject.form_data).to match_array(request_body)
    end
  end

  describe '#call' do
    context 'on success' do
      let(:file) { Tempfile.new }

      it 'makes an API call that uploads a file to a Batch' do
        expect(Nexmo::Markdown::Pipelines::Smartling::Preprocessor)
          .to receive_message_chain(:new, :call)

        allow(File).to receive(:open).and_call_original
        allow(File).to receive(:open).and_return(file)

        stub_request(:post, uri)
          .with(headers: { 'Authorization' => "Bearer #{token}", 'Content-Type' => 'multipart/form-data' })
          .to_return(
            status: 202,
            body: { 'response' => { 'code' => 'ACCEPTED', 'data' => nil } }.to_json.to_s
          )

        expect(subject.call).to eq(translation_request.file_uri)
      end
    end

    context 'on error' do
      it 'makes an API call that uploads a file to a Batch and raises an error' do
        stub_request(:post, uri)
          .to_return(
            status: 500,
            body: { 'response' => { 'code' => 'GENERAL_ERROR', 'errors' => [{ 'key' => 'general_error', 'message' => 'Unexpected server error', 'details' => {} }] } }.to_json.to_s
          )

        expect(Bugsnag).to receive(:notify).with('Translator::Smartling::API::UploadFile 500: Unexpected server error')
        expect(subject.call).to be_nil
      end
    end
  end

  describe '#file' do
    let(:tempfile) { double(Tempfile) }

    it 'returns a temp file with the processed content of the original file' do
      expect(Tempfile).to receive(:new).and_return(tempfile)
      allow(File).to receive(:read).and_call_original
      expect(File).to receive(:read)
        .with("#{Rails.configuration.docs_base_path}/_documentation/en/messages/external-accounts/overview.md")
        .and_return('file content')
      expect(Nexmo::Markdown::Pipelines::Smartling::Preprocessor)
        .to receive_message_chain(:new, :call)
        .with('file content')
      expect(tempfile).to receive(:write)
      expect(tempfile).to receive(:rewind)
      expect(tempfile).to receive(:close)

      subject.file
    end
  end
end
