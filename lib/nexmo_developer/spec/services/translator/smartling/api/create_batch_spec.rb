require 'rails_helper'

RSpec.describe Translator::Smartling::API::CreateBatch do
  let(:project_id) { 'smartling-project-id' }
  let(:job_id) { 'smartling-job-id' }
  let(:token) { 'smartling-auth-token' }
  let(:uri) { "https://api.smartling.com/job-batches-api/v2/projects/#{project_id}/batches" }
  let(:requests) do
    [
      Translator::TranslationRequest.new(
        locale: 'ja-JP',
        frequency: 15,
        path: 'messages/external-accounts/overview.md'
      ),
    ]
  end

  describe '#call' do
    subject do
      described_class.new(project_id: project_id, job_id: job_id, token: token, requests: requests)
    end

    context 'on success' do
      let(:batch_id) { 'smartling-batch-id' }

      it 'makes an API call that creates a Batch and returns its id' do
        stub_request(:post, uri)
          .with(
            headers: { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{token}" },
            body: { 'authorize' => true, 'translationJobUid' => job_id, 'fileUris' => ['messages/external-accounts/overview.md'] }
          ).to_return(
            status: 200,
            body: { 'response' => { 'code' => 'SUCCESS', 'data' => { 'batchUid' => batch_id } } }.to_json.to_s
          )

        expect(subject.call).to eq(batch_id)
      end
    end

    context 'on error' do
      it 'makes an API call that creates a Batch and notifies about it' do
        stub_request(:post, uri)
          .with(
            headers: { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{token}" },
            body: { 'authorize' => true, 'translationJobUid' => job_id, 'fileUris' => ['messages/external-accounts/overview.md'] }
          ).to_return(
            status: 500,
            body: { 'response' => { 'code' => 'GENERAL_ERROR', 'errors' => [{ 'key' => 'general_error', 'message' => 'Unexpected server error', 'details' => {} }] } }.to_json.to_s
          )

        expect(Bugsnag).to receive(:notify).with('Translator::Smartling::API::CreateBatch 500: Unexpected server error')
        expect(subject.call).to be_nil
      end
    end
  end
end
