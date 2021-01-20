require 'rails_helper'

RSpec.describe ImprovePagePresenter do
  let(:document_path) do
    "#{Rails.configuration.docs_base_path}/_documentation/en/concepts/overview.md"
  end

  subject { described_class.new(document_path) }

  describe '#github_url' do
    it 'returns the url to the doc' do
      expect(subject.github_url).to eq('https://github.com/nexmo/nexmo-developer/blob/master/_documentation/en/concepts/overview.md')
    end
  end

  describe '#docs_repo' do
    context 'when the path to the doc is in Station' do
      let(:document_path) { 'app/views/contribute/overview.md' }

      it 'returns the Station repository' do
        expect(described_class.new(document_path).docs_repo).to eq('nexmo/station')
      end
    end

    context 'when the path to the doc is outside Station' do
      it 'returns the docs repository' do
        expect(subject.docs_repo).to eq('nexmo/nexmo-developer')
      end
    end

    context 'when the path is outside Station but includes characters that might match a path in Station' do
      let(:document_path) { '_documentation/en/app-to-phone/overview.md' }

      it 'still returns the docs repository' do
        expect(described_class.new(document_path).docs_repo).to eq('nexmo/nexmo-developer')
      end
    end
  end
end
