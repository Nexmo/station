require 'rails_helper'

RSpec.describe Translator::SmartlingCoordinator do
  let(:frequency) { 15 }
  let(:accounts_overview) { Translator::TranslationRequest.new(locale: 'ja-JP', frequency: frequency, path: 'messages/external-accounts/overview.md') }
  let(:sms_overview) { Translator::TranslationRequest.new(locale: 'ja-JP', frequency: frequency, path: 'messaging/sms/overview.md') }
  let(:guides_numbers) { Translator::TranslationRequest.new(locale: 'zh-CN', frequency: frequency, path: 'voice/voice-api/guides/numbers.md') }
  let(:connect_an_inbound_call) { Translator::TranslationRequest.new(locale: 'es-ES', frequency: frequency, path: 'voice/voice-api/code-snippets/connect-an-inobound-call.md') }
  let(:requests) { [accounts_overview, sms_overview, guides_numbers, connect_an_inbound_call] }

  subject { described_class.new(requests: requests, frequency: frequency) }

  describe '#call' do
    it 'creates one Job per locale, a Batch and uploads the corresponding files to the Batch' do
      expect(subject).to receive(:create_job).exactly(3).times.and_return(nil, 'smartling-job-id-1', 'smartling-job-id-2')

      expect(subject).to receive(:create_batch).twice.and_return(nil, 'smartling-batch-id')

      expect(subject).to receive(:upload_file_to_batch).once.with('smartling-batch-id', connect_an_inbound_call)

      subject.call
    end
  end

  describe '#requests_by_locale' do
    it 'groups translations requests by locale' do
      hash = subject.requests_by_locale

      expect(hash.keys).to match_array(['ja-JP', 'zh-CN', 'es-ES'])
      expect(hash['ja-JP']).to match_array([accounts_overview, sms_overview])
      expect(hash['zh-CN']).to match_array([guides_numbers])
      expect(hash['es-ES']).to match_array([connect_an_inbound_call])
    end
  end

  describe '#due_date' do
    it 'returns the date in iso8601 format' do
      expect(subject.due_date).to eq((Time.current + frequency.days).to_s(:iso8601))
    end
  end

  describe '#create_job' do
    it 'creates a Job' do
      expect(Translator::Smartling::ApiRequestsGenerator).to receive(:create_job)
        .with(locales: ['ja-JP'], due_date: subject.due_date)

      subject.create_job('ja-JP')
    end
  end

  describe '#create_batch' do
    it 'creates a batch for a Job' do
      expect(Translator::Smartling::ApiRequestsGenerator).to receive(:create_batch)
        .with(job_id: 'smartling-job-id', requests: [])

      subject.create_batch('smartling-job-id', [])
    end
  end

  describe '#upload_file_to_batch' do
    it 'uploads a file to the Batch' do
      expect(Translator::Smartling::ApiRequestsGenerator).to receive(:upload_file)
        .with(batch_id: 'smartling-batch-id', translation_request: requests.first)

      subject.upload_file_to_batch('smartling-batch-id', requests.first)
    end
  end
end
