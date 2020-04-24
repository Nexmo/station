require 'rails_helper'

RSpec.describe Header do
  let(:items) { nil }
  let(:config) do
    {
      'name' => 'Sample Name',
      'subtitle' => 'Sample Subtitle',
      'header' => [
        'assets' => [
          'logo' => [ 
            'path' => '/images/logos/sample-logo.png',
            'alt' => 'Sample Alt'
          ],
        ],
        'links' => [
          'sign-up' => [
            'path' => 'https://path/to/site',
            'text' => ['Log In', 'Try Me']
          ],
        ]
      ]
    }
  end

  describe '#header_from_config with correct config' do
    before do
      path = "#{Rails.configuration.docs_base_path}/config/business_info.yml"
      allow_any_instance_of(described_class).to receive(:config_exist?).with(path).and_return(true)
      allow_any_instance_of(described_class).to receive(:open_config).with(path).and_return(mock_yaml)
      @header = described_class.new(
        items: items
      )
    end

    it 'returns an object with data from the config file' do
      items = @header.items

      expect(items).to eq(
        [{
          :logo_alt=>"Sample Alt",
          :logo_path=>"/images/logos/sample-logo.png",
          :name=>"Sample Name",
          :sign_up_path=>"https://path/to/site",
          :sign_up_text_arr=>["Log In", "Try Me"],
          :subtitle=>"Sample Subtitle"
        }]
      )
    end
  end

  describe '#header_from_config with no config file' do    
    it 'raises an exception' do
      path = "#{Rails.configuration.docs_base_path}/config/business_info.yml"
      allow_any_instance_of(described_class).to receive(:config_exist?).with(path).and_return(false)
      allow_any_instance_of(described_class).to receive(:open_config).with(path).and_return(nil)

      expect { described_class.new }.to raise_error(RuntimeError, 'You must provide a config/business_info.yml file in your documentation path.')
    end
  end

  def mock_yaml
    <<~HEREDOC
    name: Sample Name
    subtitle: Sample Subtitle
    header:
      assets:
        logo: 
          path: '/images/logos/sample-logo.png'
          alt: 'Sample Alt'
      links:
        sign-up:
          path:  https://path/to/site
          text:
            - 'Log In'
            - 'Try Me'
    HEREDOC
  end
end
