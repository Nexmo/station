require 'rails_helper'

RSpec.describe Translator::Smartling::FileUpload do
  describe '#upload_file' do
    it 'runs' do
      subject = described_class.new(jobs: mock_jobs_data)

      subject.upload_files
    end
  end

  def mock_jobs_data
    {
      13 => {
        'job_id' => 'abc123abc', 
        'batch_id' => 'def456def', 
        'locales' => ['en', 'cn', 'ja'], 
        'requests' => [
          Translator::TranslationRequest.new(locale: 'en', frequency: 13, path: 'voice/voice-api/guides/numbers.md'),
          Translator::TranslationRequest.new(locale: 'cn', frequency: 13, path: 'voice/voice-api/guides/numbers.md'),
          Translator::TranslationRequest.new(locale: 'ja', frequency: 13, path: 'voice/voice-api/guides/numbers.md'),
        ]
      }
    }
  end
end