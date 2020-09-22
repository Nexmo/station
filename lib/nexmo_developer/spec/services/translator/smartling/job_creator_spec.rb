require 'rails_helper'

RSpec.describe Translator::Smartling::JobCreator do
  context 'with all parameters defined' do
    ENV['SMARTLING_USER_ID'] = 'abcdefg123456789'
    ENV['SMARTLING_USER_SECRET'] = '1234567890zawrfkd'
    ENV['SMARTLING_PROJECT_ID'] = '234sdfedfg'
    let(:params) do
      {
        locales: ['en', 'ja'],
        due_date: 'Mon, 21 Sep 2020 12:37:40 UTC +00:00',
        user_id: ENV['SMARTLING_USER_ID'],
        user_secret: ENV['SMARTLING_USER_SECRET'],
        project_id: ENV['SMARTLING_PROJECT_ID'],
      }
    end
    subject { described_class.new(params) }
    it 'initializes with the correct attributes' do
      expect(subject).to have_attributes(
        job_name: a_string_starting_with('stationTranslationJob'),
        locales: ['en', 'ja'],
        due_date: 'Mon, 21 Sep 2020 12:37:40 UTC +00:00',
        user_id: 'abcdefg123456789',
        user_secret: '1234567890zawrfkd',
        project_id: '234sdfedfg'
      )
    end

    describe '#client' do
      it 'creates a Smartling SDK instance' do
        expect(subject.client).to be_an_instance_of(Smartling::Api)
      end
    end

    describe '#job_uri' do
      it 'sets the Smartling Job API URI correctly' do
        expect(subject.job_uri.as_json).to eql('https://api.smartling.com/jobs-api/v3/projects/234sdfedfg/jobs')
      end
    end

    describe '#token' do
      it 'creates a JSON Web Token for Smartling' do
        allow(subject).to receive(:token).and_return(sample_jwt)

        expect(subject.token).to eql(sample_jwt)
      end
    end

    describe '#create_job' do
      xit 'makes a successful HTTP POST request to Smartling Jobs API' do
        mock_net_http = double('http')
        # mock_net_http_post = double('Net::HTTP::Post')
        # allow(Net::HTTP).to receive(:new).and_return(mock_net_http)
        allow(mock_net_http).to receive(:use_ssl=).and_return(true)
        allow(subject).to receive(:token).and_return(sample_jwt)
        allow(subject).to receive(:create_job).and_return('abc123abc')
        # allow(Net::HTTP::Post).to receive(:new).and_return(mock_net_http_post)
        subject.create_job
        expect(mock_net_http).to receive(:request).with(hash_including(dueDate: 'Mon, 21 Sep 2020 12:37:40 UTC +00:00'))
      end

      it 'returns a translation job UUID' do
        allow(subject).to receive(:create_job).and_return('abc123abc')

        expect(subject.create_job).to eql('abc123abc')
      end
    end
  end

  def sample_jwt
    'ey65gy654t34tswfssfdsdf3.eyJdssdfkwefiews32345234124rewfwef3gwefdq3e2y04MjMyYjMxNmM2YWMiLCJlesdfw3rwef345324eqfdsjyhgwedawd23wegrgeNDcxLCJpc3MiOiJodHRwczovL3Nzby5zbWFydGxpbmcuY29tL2F1dGgvcmVhbG1zL1NtYXJ0bGluZyIsImF1ZCI6ImF1dGhlbnRpY2F0aW9uLXNlcnZpY2UiLCJzdWIiOiIyZjg2MTVjZS0wMTQ5LTQzNGYtOThhMS0yMTcxY2ZlMzE4ODUiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJhdXRoZW50aWNhdGlvbi1zZXJ2aWNlIiwic2Vzc2lvbl9zdGF0ZSI6Ijk4OGNlNDllLTJjYTUtNDhlMy1iYzIyLWMwMjQ1NzQ5NDRlNSIsImNsaWVudF9zZXNzaW9uIjoiYjVkODRmYmEtODFkMi00MWYyLWFiOGQtOTdiMGQxYTI1M2MyIiwiYWxsb3dlZC1vcmlnaW5zIjpbXSwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbIlJPTEVfQVBJX1VTRVIiLCJ1c2VyIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3rgef4523rwefdCIsInZpZXctcHJvZmlsZSJdfX0sInVpZCI6IjA2MWFlMmEyZWI2NCIsIm5hbWUiOiJuZXhtby1kZXZlbG9wZXIiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJhcGlVc2VyK3Byb2plY3QrMWRmM2I5ZGYyQHNtYXJ0bGluZy5jb20iLCJnaXZlbl9uYW1lIjoiQVBJIFVzZXIiLCJmYW1pbHlfbmFtZSI6Im5leG1vLWRldmVsb3BlciIsImVtYWlsIjoiYXBpVXNlcitwcm9qZWN0KzFkZjNiOWRmMkBzbWFydGxpbmcuY29tIn0.X_cXsqYXrxJzoBpRr3W0duiwPv72QHWtQ02Rhs_ZH9-nGmBb7jZ2MtwX-QOMJanIjFGeCwfsf3ozEemWY3HvpwFqv55HOFt2uVAFj3mLiADtSbKKiV-ixh5sY1pAcsjgNeQ-feMXjwpOIFgqQOWDhwc_yvDqAk9wKdMECMNcYa8'
  end
end
