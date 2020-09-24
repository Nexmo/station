require 'rails_helper'

RSpec.describe Translator::Smartling::FileUpload do
  describe '#upload_file' do
    it 'runs' do
      allow(Translator::Smartling::TokenGenerator).to receive(:token).and_return(sample_jwt)
      allow_any_instance_of(Translator::Smartling::ApiRequestsGenerator).to receive(:create).and_return(mock_upload_request_payload)
      allow_any_instance_of(Translator::Smartling::ApiRequestsGenerator).to receive(:validate_success).with(mock_upload_success_payload, 202).and_return(mock_upload_success_payload)

      subject = described_class.new(
        batch_id: 'batch1',
        locales: ['en', 'cn', 'ja'],
        docs: mock_docs_parameter
      )

      subject.upload_files
    end
  end

  def mock_docs_parameter
    [
      Translator::TranslationRequest.new(locale: 'en', frequency: 13, path: 'voice/voice-api/guides/numbers.md'),
      Translator::TranslationRequest.new(locale: 'cn', frequency: 13, path: 'voice/voice-api/guides/numbers.md'),
      Translator::TranslationRequest.new(locale: 'ja', frequency: 13, path: 'voice/voice-api/guides/numbers.md'),
    ]
  end

  def sample_jwt
    'ey65gy654t34tswfssfdsdf3.eyJdssdfkwefiews32345234124rewfwef3gwefdq3e2y04MjMyYjMxNmM2YWMiLCJlesdfw3rwef345324eqfdsjyhgwedawd23wegrgeNDcxLCJpc3MiOiJodHRwczovL3Nzby5zbWFydGxpbmcuY29tL2F1dGgvcmVhbG1zL1NtYXJ0bGluZyIsImF1ZCI6ImF1dGhlbnRpY2F0aW9uLXNlcnZpY2UiLCJzdWIiOiIyZjg2MTVjZS0wMTQ5LTQzNGYtOThhMS0yMTcxY2ZlMzE4ODUiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJhdXRoZW50aWNhdGlvbi1zZXJ2aWNlIiwic2Vzc2lvbl9zdGF0ZSI6Ijk4OGNlNDllLTJjYTUtNDhlMy1iYzIyLWMwMjQ1NzQ5NDRlNSIsImNsaWVudF9zZXNzaW9uIjoiYjVkODRmYmEtODFkMi00MWYyLWFiOGQtOTdiMGQxYTI1M2MyIiwiYWxsb3dlZC1vcmlnaW5zIjpbXSwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbIlJPTEVfQVBJX1VTRVIiLCJ1c2VyIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3rgef4523rwefdCIsInZpZXctcHJvZmlsZSJdfX0sInVpZCI6IjA2MWFlMmEyZWI2NCIsIm5hbWUiOiJuZXhtby1kZXZlbG9wZXIiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJhcGlVc2VyK3Byb2plY3QrMWRmM2I5ZGYyQHNtYXJ0bGluZy5jb20iLCJnaXZlbl9uYW1lIjoiQVBJIFVzZXIiLCJmYW1pbHlfbmFtZSI6Im5leG1vLWRldmVsb3BlciIsImVtYWlsIjoiYXBpVXNlcitwcm9qZWN0KzFkZjNiOWRmMkBzbWFydGxpbmcuY29tIn0.X_cXsqYXrxJzoBpRr3W0duiwPv72QHWtQ02Rhs_ZH9-nGmBb7jZ2MtwX-QOMJanIjFGeCwfsf3ozEemWY3HvpwFqv55HOFt2uVAFj3mLiADtSbKKiV-ixh5sY1pAcsjgNeQ-feMXjwpOIFgqQOWDhwc_yvDqAk9wKdMECMNcYa8'
  end

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
end
