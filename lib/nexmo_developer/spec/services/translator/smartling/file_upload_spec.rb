require 'rails_helper'

RSpec.describe Translator::Smartling::FileUpload do
  describe '#initiate_upload' do
    it 'runs' do
      mock_net_http = double('Net::HTTP')
      allow(Net::HTTP).to receive(:new).and_return(mock_net_http)
      allow(mock_net_http).to receive(:use_ssl=).and_return(true)

      mock_net_http_post = double('Net::HTTP::Post')
      expect(Net::HTTP::Post).to receive(:new).exactly(3).times.and_return(mock_net_http_post)

      response = Net::HTTPSuccess.new(1.1, 202, 'OK')
      expect(response).to receive(:body).exactly(3).times.and_return('{"response":{"code":"SUCCESS", "data":{"message":"Your file was successfully uploaded. Word and string counts are not available right now."}}}')

      expect(mock_net_http_post).to receive(:body=).exactly(3).times.with(kind_of(String))

      expect(mock_net_http).to receive(:request).exactly(3).times.with(mock_net_http_post).and_return(response)

      allow(Translator::Smartling::TokenGenerator).to receive(:token).and_return(sample_jwt)

      subject = described_class.new(
        batch_id: 'batch1',
        locales: ['en', 'cn', 'ja'],
        docs: mock_docs_parameter
      )

      result = subject.initiate_upload

      # mock success in anticipation of building the execute job actions
      expect(result).to eql('move on to execute job action')
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
end
