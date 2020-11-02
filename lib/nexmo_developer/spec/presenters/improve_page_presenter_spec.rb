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
end
