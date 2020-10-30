require 'rails_helper'

RSpec.describe Translator::Smartling::ApiRequestsGenerator do
  let(:token) { 'smartling-auth-token' }
  let(:project_id) { described_class.project_id }

  describe '.create_job' do
    let(:due_date) { Time.current.to_date }
    let(:locales) { ['ja-JP'] }

    before { allow(described_class).to receive(:token).and_return(token) }

    it 'generates an API call that creates a Job' do
      expect(Translator::Smartling::API::CreateJob)
        .to receive(:call)
        .with(locales: locales, due_date: due_date, project_id: project_id, token: token)

      described_class.create_job(locales: locales, due_date: due_date)
    end
  end

  describe '.create_batch' do
    let(:job_id) { 'smartling-job-id' }
    let(:requests) { [] }

    before { allow(described_class).to receive(:token).and_return(token) }

    it 'generates an API call that creates a Batch' do
      expect(Translator::Smartling::API::CreateBatch)
        .to receive(:call)
        .with(project_id: project_id, token: token, job_id: job_id, requests: requests)

      described_class.create_batch(job_id: job_id, requests: requests)
    end
  end

  describe '.upload_file' do
    let(:batch_id) { 'smartling-batch-id' }
    let(:translation_request) { double(Translator::TranslationRequest) }

    before { allow(described_class).to receive(:token).and_return(token) }

    it 'generates an API call that uploads a file to a batch' do
      expect(Translator::Smartling::API::UploadFile)
        .to receive(:call)
        .with(project_id: project_id, batch_id: batch_id, translation_request: translation_request, token: token)

      described_class.upload_file(batch_id: batch_id, translation_request: translation_request)
    end
  end

  describe '.file_paths' do
    before { allow(described_class).to receive(:token).and_return(token) }

    it 'generates an API call that generates a list of recently published file paths' do
      expect(Translator::Smartling::API::FilePaths)
        .to receive(:call)
        .with(project_id: project_id, token: token)

      described_class.file_paths
    end
  end

  describe '.get_file_status' do
    let(:path) { 'voice/voice-api/guides/numbers.md' }

    before { allow(described_class).to receive(:token).and_return(token) }

    it 'generates an API call that gets the status of a file in Smartling' do
      expect(Translator::Smartling::API::FileStatus)
        .to receive(:call)
        .with(project_id: project_id, token: token, path: path)

      described_class.get_file_status(path: path)
    end
  end

  describe '.token' do
    it 'returns the authentication token' do
      expect(Translator::Smartling::TokenGenerator).to receive(:token)
      described_class.token
    end
  end
end
