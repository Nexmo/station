require 'rails_helper'

RSpec.describe Head do
  let(:items) { nil }
  let(:path) { "#{Rails.configuration.docs_base_path}/config/header_meta.yml" }
  let(:meta_base_path) { "#{Rails.configuration.docs_base_path}/public/meta" }
  let(:config) do
    {
      'title' => 'Vonage',
      'description' => 'A Description',
      'google-site-verification' => '123456',
      'application-name' => 'Vonage Business Cloud'
    }
  end
  let(:yml) do
    <<~HEREDOC
      title: 'Vonage'
      description: 'A Description'
      google-site-verification: '123456'
      application-name: 'Vonage Business Cloud'
    HEREDOC
  end

  describe '#head_from_config with correct config' do
    subject { described_class.new(items: items) }

    it 'returns an object with data from the config file' do
      items = subject.items

      expect(items).to eq(
        {
          title: 'Vonage API Developer',
          description: 'A Description',
          google_site_verification: '123456',
          application_name: 'Vonage API Developer',
          og_image: 'meta/nexmo-developer-card.png',
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
      allow_any_instance_of(described_class).to receive(:config_exist?).with(path).and_return(false)
      allow_any_instance_of(described_class).to receive(:open_config).with(path).and_return(nil)

      expect { described_class.new }.to raise_error(RuntimeError, 'You must provide a config/header_meta.yml file in your documentation path.')
    end
  end
end
