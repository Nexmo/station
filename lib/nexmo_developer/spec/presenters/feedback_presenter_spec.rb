require 'rails_helper'

RSpec.describe FeedbackPresenter do
  let(:canonical_url) { 'https://developer.nexmo.com' }
  let(:feedback) { YAML.safe_load(File.read("#{Rails.root}/config/feedback.yml")) }

  subject { described_class.new(canonical_url) }

  describe '#props' do
    it 'returns a json object that acts as props for the vue component' do
      expect(subject.props['source']).to eq(canonical_url)
      expect(subject.props['configId']).to eq(Feedback::Config.last.id)
      expect(subject.props['title']).to eq(feedback['title'])
      expect(subject.props['paths']).to eq(feedback['paths'])
    end
  end
end
