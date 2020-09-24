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

  describe '#coordinate_jobs' do
    it 'returns multiple translation frequency keys for multiple jobs requests' do
      ENV['SMARTLING_USER_ID'] = 'abcdefg123456789'
      ENV['SMARTLING_USER_SECRET'] = '1234567890zawrfkd'
      ENV['SMARTLING_PROJECT_ID'] = '234sdfedfg'

      first_job = double('Translator::Smartling::JobCreator')
      first_batch = double('Translator::Smartling::BatchCreator')
      second_job = double('Translator::Smartling::JobCreator')
      second_batch = double('Translator::Smartling::BatchCreator')

      # rubocop:disable Rails/TimeZone
      allow(Time).to receive_message_chain(:zone, :now).and_return(Time.parse('August 23, 2020'))
      # rubocop:enable Rails/TimeZone
      allow(Translator::Smartling::TokenGenerator).to receive(:token).and_return(sample_jwt)
      allow_any_instance_of(Translator::Smartling::ApiRequestsGenerator).to receive(:create).and_return(mock_upload_request_payload)
      allow_any_instance_of(Translator::Smartling::ApiRequestsGenerator).to receive(:validate_success).with(mock_upload_success_payload, 202).and_return(mock_upload_success_payload)
      allow(Translator::Smartling::JobCreator).to receive(:new).with(mock_job_creator_new_first_job).and_return(first_job)
      allow(Translator::Smartling::JobCreator).to receive(:new).with(mock_job_creator_new_second_job).and_return(second_job)
      allow(Translator::Smartling::BatchCreator).to receive(:new).with(jobId: 'job1').and_return(first_batch)
      allow(Translator::Smartling::BatchCreator).to receive(:new).with(jobId: 'job2').and_return(second_batch)

      allow(first_job).to receive(:create_job).and_return('job1')
      allow(first_batch).to receive(:create_batch).and_return('batch1')
      allow(second_job).to receive(:create_job).and_return('job2')
      allow(second_batch).to receive(:create_batch).and_return('batch2')

      result = described_class.new(jobs: mock_multiple_jobs_data).coordinate_jobs

      expect(result.values[0]['job_id']).to eql('job2')
      expect(result.values[1]['job_id']).to eql('job1')
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
        Translator::TranslationRequest.new(locale: 'cn', frequency: 15, path: 'messages/external-accounts/overview.md'),
        Translator::TranslationRequest.new(locale: 'ja', frequency: 15, path: 'messages/external-accounts/overview.md'),
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

  def mock_job_creator_new_first_job
    {
      locales: ['en', 'cn', 'ja'],
      due_date: '2020-09-05 00:00:00 +0300',
    }
  end

  # rubocop:disable Rails/TimeZone
  def mock_job_creator_new_second_job
    {
      locales: ['en', 'cn', 'ja'],
      due_date: Time.parse('2020-09-07 00:00:00.000000000 +0300'),
    }
  end
  # rubocop:enable Rails/TimeZone

  def mock_upload_request_payload
    {
      'response' => {
        'code' => 'SUCCESS',
        'data' => [
          {
            'message' => 'Your file was successfully uploaded. Word and string counts are not available right now.',
          },
        ],
      },
    }
  end

  def mock_upload_success_payload
    {
      response: {
        code: 'SUCCESS',
        data: {
          message: 'Your file was successfully uploaded. Word and string counts are not available right now.',
        },
      },
    }
  end

  def sample_jwt
    'ey65gy654t34tswfssfdsdf3.eyJdssdfkwefiews32345234124rewfwef3gwefdq3e2y04MjMyYjMxNmM2YWMiLCJlesdfw3rwef345324eqfdsjyhgwedawd23wegrgeNDcxLCJpc3MiOiJodHRwczovL3Nzby5zbWFydGxpbmcuY29tL2F1dGgvcmVhbG1zL1NtYXJ0bGluZyIsImF1ZCI6ImF1dGhlbnRpY2F0aW9uLXNlcnZpY2UiLCJzdWIiOiIyZjg2MTVjZS0wMTQ5LTQzNGYtOThhMS0yMTcxY2ZlMzE4ODUiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJhdXRoZW50aWNhdGlvbi1zZXJ2aWNlIiwic2Vzc2lvbl9zdGF0ZSI6Ijk4OGNlNDllLTJjYTUtNDhlMy1iYzIyLWMwMjQ1NzQ5NDRlNSIsImNsaWVudF9zZXNzaW9uIjoiYjVkODRmYmEtODFkMi00MWYyLWFiOGQtOTdiMGQxYTI1M2MyIiwiYWxsb3dlZC1vcmlnaW5zIjpbXSwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbIlJPTEVfQVBJX1VTRVIiLCJ1c2VyIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3rgef4523rwefdCIsInZpZXctcHJvZmlsZSJdfX0sInVpZCI6IjA2MWFlMmEyZWI2NCIsIm5hbWUiOiJuZXhtby1kZXZlbG9wZXIiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJhcGlVc2VyK3Byb2plY3QrMWRmM2I5ZGYyQHNtYXJ0bGluZy5jb20iLCJnaXZlbl9uYW1lIjoiQVBJIFVzZXIiLCJmYW1pbHlfbmFtZSI6Im5leG1vLWRldmVsb3BlciIsImVtYWlsIjoiYXBpVXNlcitwcm9qZWN0KzFkZjNiOWRmMkBzbWFydGxpbmcuY29tIn0.X_cXsqYXrxJzoBpRr3W0duiwPv72QHWtQ02Rhs_ZH9-nGmBb7jZ2MtwX-QOMJanIjFGeCwfsf3ozEemWY3HvpwFqv55HOFt2uVAFj3mLiADtSbKKiV-ixh5sY1pAcsjgNeQ-feMXjwpOIFgqQOWDhwc_yvDqAk9wKdMECMNcYa8'
  end
end
