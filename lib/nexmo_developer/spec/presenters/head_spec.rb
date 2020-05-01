require 'rails_helper'

RSpec.describe Head do
  let(:items) { nil }
  let(:config) do
    {
      'title' => 'Vonage',
      'description' => 'A Description',
      'google-site-verification' => '123456',
      'application-name' => 'Vonage Business Cloud'
    }
  end

  describe '#head_from_config with correct config' do
    before do
      path = "#{Rails.configuration.docs_base_path}/config/header_meta.yml"
      meta_base_path = "#{Rails.configuration.docs_base_path}/public/meta"
      allow_any_instance_of(described_class).to receive(:config_exist?).with(path).and_return(true)
      allow_any_instance_of(described_class).to receive(:open_config).with(path).and_return(mock_yaml)
      allow_any_instance_of(described_class).to receive(:file_does_not_exist?).with("#{meta_base_path}/og.png").and_return(false)
      allow_any_instance_of(described_class).to receive(:file_does_not_exist?).with("#{meta_base_path}/apple-touch-icon.png").and_return(false)
      allow_any_instance_of(described_class).to receive(:file_does_not_exist?).with("#{meta_base_path}/favicon.ico").and_return(false)
      allow_any_instance_of(described_class).to receive(:file_does_not_exist?).with("#{meta_base_path}/favicon-32x32.png").and_return(false)
      allow_any_instance_of(described_class).to receive(:file_does_not_exist?).with("#{meta_base_path}/manifest.json").and_return(false)
      allow_any_instance_of(described_class).to receive(:file_does_not_exist?).with("#{meta_base_path}/safari-pinned-tab.svg").and_return(false)
      allow_any_instance_of(described_class).to receive(:file_does_not_exist?).with("#{meta_base_path}/mstile-144x144.png").and_return(false)
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
          og_image: 'meta/og.png',
          og_image_width: 835,
          og_image_height: 437,
          apple_touch_icon: 'meta/apple-touch-icon.png',
          manifest: 'meta/manifest.json',
          mstile_144_squared: 'meta/mstile-144x144.png',
          safari_pinned_tab: 'meta/safari-pinned-tab.svg',
          favicon: 'meta/favicon.ico',
          favicon_32_squared: 'meta/favicon-32x32.png'
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
    HEREDOC
  end
end
