require 'rails_helper'

RSpec.describe Translator::Smartling::ApiRequestsGenerator do
  before(:each) do
    allow(Translator::Smartling::TokenGenerator).to receive(:token).and_return(sample_jwt)
  end

  context 'with a new Smartling Jobs API request' do
    let(:params) do
      {
        action: 'job',
        uri: 'https://api.smartling.com/jobs-api/v3/projects/234sdfedfg/jobs',
        token: sample_jwt,
        body: {
          'jobName' => 'ADP Translation Job: Tue, 22 Sep 2020 10:47:58 UTC +00:00',
          'targetLocaleIds' => ['en', 'ja'],
          'dueDate' => 'Thu, 24 Sep 2020 12:37:40 UTC +00:00',
        },
      }
    end
    subject { described_class.new(params) }

    it 'initializes with the correct parameters' do
      expect(subject).to have_attributes(
        action: 'job',
        uri: URI('https://api.smartling.com/jobs-api/v3/projects/234sdfedfg/jobs'),
        token: sample_jwt,
        body: {
          'jobName' => 'ADP Translation Job: Tue, 22 Sep 2020 10:47:58 UTC +00:00',
          'targetLocaleIds' => ['en', 'ja'],
          'dueDate' => 'Thu, 24 Sep 2020 12:37:40 UTC +00:00',
        }
      )
    end

    describe '#create' do
      it 'makes a successful HTTP POST request to Smartling Jobs API' do
        mock_net_http = double('Net::HTTP')
        allow(Net::HTTP).to receive(:new).and_return(mock_net_http)
        allow(mock_net_http).to receive(:use_ssl=).and_return(true)

        mock_net_http_post = double('Net::HTTP::Post')
        expect(Net::HTTP::Post).to receive(:new).and_return(mock_net_http_post)

        response = Net::HTTPSuccess.new(1.1, 200, 'OK')
        expect(response).to receive(:body).and_return('{"data": {"translationJobUuid": "uuid-translation"}}')

        expect(mock_net_http_post).to receive(:body=)
          .with('{"jobName":"ADP Translation Job: Tue, 22 Sep 2020 10:47:58 UTC +00:00","targetLocaleIds":["en","ja"],"dueDate":"Thu, 24 Sep 2020 12:37:40 UTC +00:00"}')

        expect(mock_net_http).to receive(:request).with(mock_net_http_post).and_return(response)
        expect(subject.create).to eq('uuid-translation')
      end

      it 'returns a translation job UUID' do
        allow(subject).to receive(:create).and_return('abc123abc')

        expect(subject.create).to eql('abc123abc')
      end
    end

    describe '#validate_success' do
      context 'with a new job successfully created' do
        it 'returns the job UUID' do
          expect(subject.validate_success(mock_job_success_message, 200)).to eql('abc123abc')
        end
      end

      context 'with an unsuccessful job attempt' do
        it 'raises the Smartling error code as an exception' do
          expect { subject.validate_success(mock_error_message, 401) }.to raise_error(ArgumentError, '401: AUTHENTICATION_ERROR')
        end
      end
    end
  end

  context 'with a new Smartling Batches API request' do
    let(:params) do
      {
        action: 'batch',
        uri: 'https://api.smartling.com/jobs-batch-api/v1/projects/234sdfedfg/batches',
        token: sample_jwt,
        body: { 'translationJobUuid' => 'abc123abc' },
      }
    end
    subject { described_class.new(params) }

    it 'initializes with the correct parameters' do
      expect(subject).to have_attributes(
        action: 'batch',
        uri: URI('https://api.smartling.com/jobs-batch-api/v1/projects/234sdfedfg/batches'),
        token: sample_jwt,
        body: { 'translationJobUuid' => 'abc123abc' }
      )
    end

    describe '#validate_success' do
      context 'with a new batch successfully created' do
        it 'returns the batch UUID' do
          expect(subject.validate_success(mock_batch_success_message, 200)).to eql('qwe0rty98poi')
        end
      end

      context 'with an unsuccessful batch attempt' do
        it 'raises the Smartling error code as an exception' do
          expect { subject.validate_success(mock_error_message, 401) }.to raise_error(ArgumentError, '401: AUTHENTICATION_ERROR')
        end
      end
    end
  end

  def sample_jwt
    'ey65gy654t34tswfssfdsdf3.eyJdssdfkwefiews32345234124rewfwef3gwefdq3e2y04MjMyYjMxNmM2YWMiLCJlesdfw3rwef345324eqfdsjyhgwedawd23wegrgeNDcxLCJpc3MiOiJodHRwczovL3Nzby5zbWFydGxpbmcuY29tL2F1dGgvcmVhbG1zL1NtYXJ0bGluZyIsImF1ZCI6ImF1dGhlbnRpY2F0aW9uLXNlcnZpY2UiLCJzdWIiOiIyZjg2MTVjZS0wMTQ5LTQzNGYtOThhMS0yMTcxY2ZlMzE4ODUiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJhdXRoZW50aWNhdGlvbi1zZXJ2aWNlIiwic2Vzc2lvbl9zdGF0ZSI6Ijk4OGNlNDllLTJjYTUtNDhlMy1iYzIyLWMwMjQ1NzQ5NDRlNSIsImNsaWVudF9zZXNzaW9uIjoiYjVkODRmYmEtODFkMi00MWYyLWFiOGQtOTdiMGQxYTI1M2MyIiwiYWxsb3dlZC1vcmlnaW5zIjpbXSwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbIlJPTEVfQVBJX1VTRVIiLCJ1c2VyIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3rgef4523rwefdCIsInZpZXctcHJvZmlsZSJdfX0sInVpZCI6IjA2MWFlMmEyZWI2NCIsIm5hbWUiOiJuZXhtby1kZXZlbG9wZXIiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJhcGlVc2VyK3Byb2plY3QrMWRmM2I5ZGYyQHNtYXJ0bGluZy5jb20iLCJnaXZlbl9uYW1lIjoiQVBJIFVzZXIiLCJmYW1pbHlfbmFtZSI6Im5leG1vLWRldmVsb3BlciIsImVtYWlsIjoiYXBpVXNlcitwcm9qZWN0KzFkZjNiOWRmMkBzbWFydGxpbmcuY29tIn0.X_cXsqYXrxJzoBpRr3W0duiwPv72QHWtQ02Rhs_ZH9-nGmBb7jZ2MtwX-QOMJanIjFGeCwfsf3ozEemWY3HvpwFqv55HOFt2uVAFj3mLiADtSbKKiV-ixh5sY1pAcsjgNeQ-feMXjwpOIFgqQOWDhwc_yvDqAk9wKdMECMNcYa8'
  end

  def mock_job_success_message
    {
      'response' => {
        'code' => 'SUCCESS',
      },
      'data' => {
        'translationJobUuid' => 'abc123abc',
      },
    }
  end

  def mock_batch_success_message
    {
      'response' => {
        'code' => 'SUCCESS',
      },
      'data' => {
        'batchUuid' => 'qwe0rty98poi',
      },
    }
  end

  def mock_error_message
    {
      'response' => {
        'code' => 'AUTHENTICATION_ERROR',
      },
      'errors' => {
        'message' => 'Invalid token',
      },
    }
  end
end
