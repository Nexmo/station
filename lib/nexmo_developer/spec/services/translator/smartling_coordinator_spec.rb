require 'rails_helper'

RSpec.describe Translator::SmartlingCoordinator do
  describe '#new' do
    it 'returns an empty jobs attribute if the jobs parameter is an empty hash' do
      subject = described_class.new(jobs: {})

      expect(subject.coordinate_jobs).to eql({})
    end

    it 'raises an exception for incorrect parameter types' do
      expect { described_class.new(jobs: 'Hello') }.to raise_error(ArgumentError, "Expected the 'jobs' parameter to be a Hash")
    end

    it 'raises an exception for incorrect parameter value types' do
      expect { described_class.new(jobs: { 13 => ['a', 'b'], 15 => 'bar' }) }.to raise_error(ArgumentError, "Expected the value of the 'jobs' parameter to be an Array")
    end
  end

  describe '#coordinate_job' do
    it 'returns multiple translation frequency keys for multiple jobs requests' do
      allow_any_instance_of(Translator::Smartling::JobCreator).to receive(:create_job).and_return('abc123abc')
      allow_any_instance_of(Translator::Smartling::BatchCreator).to receive(:create_batch).and_return('def456def')
      subject = described_class.new(jobs: mock_multiple_jobs_data)

      expect(subject.coordinate_jobs).to have_key(13)
      expect(subject.coordinate_jobs).to have_key(15)
    end
  end

  describe '#locales' do
    it 'returns an array of unique locales strings' do
      subject = described_class.new(jobs: mock_multiple_jobs_data)
      expect(subject.locales(mock_requests)).to eql(['en', 'cn', 'ja'])
    end
  end

  describe '#frequency' do
    let(:time) { Time.zone.now }

    it 'calculates a due date based on the translation frequency' do
      subject = described_class.new(jobs: mock_multiple_jobs_data)
      allow(Time).to receive_message_chain(:zone, :now).and_return(time)
      frequency = 10

      expect(subject.due_date(frequency)).to eql(time + frequency.days)
    end
  end

  def mock_multiple_jobs_data
    {
      13 => [
        Translator::TranslationRequest.new(locale: 'en', frequency: 13, path: 'voice/voice-api/guides/numbers.md'),
        Translator::TranslationRequest.new(locale: 'cn', frequency: 13, path: 'voice/voice-api/guides/numbers.md'),
        Translator::TranslationRequest.new(locale: 'ja', frequency: 13, path: 'voice/voice-api/guides/numbers.md'),
      ],
      15 => [
        Translator::TranslationRequest.new(locale: 'en', frequency: 15, path: 'messages/external-accounts/overview.md'),
        Translator::TranslationRequest.new(locale: 'en', frequency: 15, path: 'messages/external-accounts/overview.md'),
        Translator::TranslationRequest.new(locale: 'en', frequency: 15, path: 'messages/external-accounts/overview.md'),
      ],
    }
  end

  def mock_requests
    [
      Translator::TranslationRequest.new(locale: 'en', frequency: 13, path: 'voice/voice-api/guides/numbers.md'),
      Translator::TranslationRequest.new(locale: 'cn', frequency: 13, path: 'voice/voice-api/guides/numbers.md'),
      Translator::TranslationRequest.new(locale: 'ja', frequency: 13, path: 'voice/voice-api/guides/numbers.md'),
    ]
  end
end
