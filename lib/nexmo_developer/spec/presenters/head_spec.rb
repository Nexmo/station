require 'rails_helper'

RSpec.describe Head do
  let(:items) { nil }
  let(:config) do
    {
      'title' => 'Vonage',
      'description' => 'A Description',
      'google-site-verification' => '123456',
      'application-name' => 'Vonage Business Cloud',
      'og-image' => 'images/sample.png',
      'og-image-width' => 835,
      'og-image-height' => 437
    }
  end

  describe '#head_from_config with correct config' do
    before do
      path = "#{Rails.configuration.docs_base_path}/config/header_meta.yml"
      allow_any_instance_of(described_class).to receive(:config_exist?).with(path).and_return(true)
      allow_any_instance_of(described_class).to receive(:open_config).with(path).and_return(mock_yaml)
      @head = described_class.new(
        items: items
      )
    end

    it 'returns an object with data from the config file' do
      items = @head.items

      expect(items).to eq(
        {
          title: 'Vonage',
          description: 'A Description',
          google_site_verification: '123456',
          application_name: 'Vonage Business Cloud',
          og_image: 'images/sample.png',
          og_image_width: 835,
          og_image_height: 437
        }
      )
    end
  end

  describe '#head_from_config with no config file' do    
    it 'raises an exception' do
      path = "#{Rails.configuration.docs_base_path}/config/header_meta.yml"
      allow_any_instance_of(described_class).to receive(:config_exist?).with(path).and_return(false)
      allow_any_instance_of(described_class).to receive(:open_config).with(path).and_return(nil)

      expect { described_class.new }.to raise_error(RuntimeError, 'You must provide a config/header_meta.yml file in your documentation path.')
    end
  end

  def mock_yaml
    <<~HEREDOC
      title: 'Vonage'
      description: 'A Description'
      google-site-verification: '123456'
      application-name: 'Vonage Business Cloud'
      og-image: images/sample.png
      og-image-width: 835
      og-image-height: 437    
    HEREDOC
  end
end
