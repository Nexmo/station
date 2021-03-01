require 'rails_helper'

RSpec.describe OrbitFeedbackNotifier do
  let(:uri) { 'https://app.orbit.love/api/v1/test-workspace/activities' }
  let(:config_file) { "#{Rails.configuration.docs_base_path}/config/feedback.yml" }
  let!(:config) { Feedback::Config.find_or_create_config(YAML.safe_load(File.read(config_file))) }
  let!(:feedback) do
    Feedback::Feedback.new(
      config: config,
      sentiment: 'positive',
      path: 0,
      steps: ['nothing!'],
      owner: Feedback::Author.new(email: 'devrel@vonage.com'),
      resource: Feedback::Resource.new(uri: 'https://example.com/docs')
    )
  end

  subject { described_class.new(feedback) }

  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('ORBIT_API_KEY').and_return('api_key')
    allow(ENV).to receive(:[]).with('ORBIT_WORKSPACE_ID').and_return('test-workspace')
  end

  describe '#post!' do
    it 'sends the new feedback to Orbit' do
      stub_request(:post, uri)
        .with(headers: { 'Authorization' => "Bearer #{ENV['ORBIT_API_KEY']}", 'Content-Type' => 'application/json' })
        .to_return(status: 200)

      subject.post!
    end
  end
end
