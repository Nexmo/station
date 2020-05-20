require 'rails_helper'

RSpec.describe Topnav do
  let(:items) { nil }
  let(:config) do
    {
      'documentation' => '/documentation',
    }
  end

  describe '#navbar_items_from_config with correct config' do
    before do
      path = "#{Rails.configuration.docs_base_path}/config/top_navigation.yml"
      allow_any_instance_of(described_class).to receive(:config_exist?).with(path).and_return(true)
      allow_any_instance_of(described_class).to receive(:open_config).with(path).and_return(mock_yaml)
      @topnav = described_class.new(
        items: items
      )
    end

    it 'returns an object with data from the config file' do
      items = @topnav.items

      expect(items).to eq(
        [{
          name: 'Documentation',
          navigation: 'documentation',
          url: '/documentation',
        }]
      )
    end
  end

  describe '#navbar_items_from_config with no config file' do
    it 'raises an exception' do
      path = "#{Rails.configuration.docs_base_path}/config/top_navigation.yml"
      allow_any_instance_of(described_class).to receive(:config_exist?).with(path).and_return(false)
      allow_any_instance_of(described_class).to receive(:open_config).with(path).and_return(nil)

      expect { described_class.new }.to raise_error(RuntimeError, 'You must provide a config/top_navigation.yml file in your documentation path.')
    end
  end

  def mock_yaml
    <<~HEREDOC
      documentation: "/documentation"
    HEREDOC
  end
end
