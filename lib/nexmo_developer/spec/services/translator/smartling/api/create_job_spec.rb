require 'rails_helper'

RSpec.describe Translator::Smartling::API::CreateJob do
  let(:project_id) { 'smartling-project-id' }
  let(:uri) { "https://api.smartling.com/jobs-api/v3/projects/#{project_id}/jobs" }
  let(:token) { 'smartling-auth-token' }
  let(:locales) { ['ja-JP'] }
  let(:job_id) { 'smartling-job-id' }
  let(:due_date) { Time.current.to_date }

  describe '#call' do
    subject do
      described_class.new(project_id: project_id, locales: locales, token: token, due_date: due_date)
    end

    context 'on success' do
      it 'makes an API call that creates a Job and returns its id' do
        stub_request(:post, uri)
          .with(
            headers: { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{token}" },
            body: { 'targetLocaleIds' => locales, 'dueDate' => due_date.to_s, 'jobName' => "ADP Translation Job: ja-JP - #{Time.current.to_date}" }
          ).to_return(
            status: 200,
            body: { 'response' => { 'code' => 'SUCCESS', 'data' => { 'translationJobUid' => job_id } } }.to_json.to_s
          )

        expect(subject.call).to eq(job_id)
      end
    end

    context 'on error' do
      it 'makes an API call that creates a Batch and raises an error' do
        stub_request(:post, uri)
          .with(
            headers: { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{token}" },
            body: { 'targetLocaleIds' => locales, 'dueDate' => due_date.to_s, 'jobName' => "ADP Translation Job: ja-JP - #{Time.current.to_date}" }
          ).to_return(
            status: 500,
            body: { 'response' => { 'code' => 'GENERAL_ERROR', 'errors' => [{ 'key' => 'general_error', 'message' => 'Unexpected server error', 'details' => {} }] } }.to_json.to_s
          )

        expect(Bugsnag).to receive(:notify).with('Translator::Smartling::API::CreateJob 500: Unexpected server error')
        expect(subject.call).to be_nil
      end
    end
  end
end
