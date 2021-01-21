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

    context 'when the doc is inside Station' do
      let(:document_path) { 'app/views/contribute/overview.md' }

      it 'returns a url to the doc in Station' do
        expect(described_class.new(document_path).github_url).to eq('https://github.com/nexmo/station/blob/master/lib/nexmo_developer/app/views/contribute/overview.md')
      end
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

  describe '#path_to_url' do
    context 'with a path to a doc in Station' do
      let(:document_path) { 'app/views/contribute/overview.md' }

      it 'returns a proper Station path' do
        expect(described_class.new(document_path).path_to_url).to eq('lib/nexmo_developer/app/views/contribute/overview.md')
      end
    end

    context 'with a path to a doc in a docs portal repository' do
      it 'returns a path not modified for Station' do
        expect(subject.path_to_url).to eq('_documentation/en/concepts/overview.md')
      end
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

  describe '#path_to_url' do
    context 'with a path to a doc in Station' do
      let(:document_path) { 'app/views/contribute/overview.md' }

      it 'returns a proper Station path' do
        expect(described_class.new(document_path).path_to_url).to eq('lib/nexmo_developer/app/views/contribute/overview.md')
      end
    end

    context 'with a path to a doc in a docs portal repository' do
      it 'returns a path not modified for Station' do
        expect(subject.path_to_url).to eq('_documentation/en/concepts/overview.md')
      end
    end
  end
end
