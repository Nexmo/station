require 'rails_helper'

RSpec.describe Header do
  let(:items) { nil }
  let(:path) { "#{Rails.configuration.docs_base_path}/config/business_info.yml" }
  let(:config) do
    {
      'name' => 'Sample Name',
      'subtitle' => 'Sample Subtitle',
      'assets' => [
        'logo' => [
          'path' => '/images/logos/sample-logo.png',
          'alt' => 'Sample Alt',
        ],
      ],
      'header' => [
        'links' => [
          'sign-up' => [
            'path' => 'https://path/to/site',
            'text' => ['Log In', 'Try Me'],
          ],
        ],
        'hiring' => [
          'display' => true,
        ],
      ],
    }
  end
  let(:yaml) do
    <<~HEREDOC
      name: Sample Name
      subtitle: Sample Subtitle
      assets:
        logo:
          path: '/images/logos/sample-logo.png'
          alt: 'Sample Alt'
      header:
        links:
          sign-up:
            path:  https://path/to/site
            text:
              - 'Log In'
              - 'Try Me'
        hiring:
          display: true
    HEREDOC
  end

  describe '#header_from_config with correct config' do
    before do
      @header = described_class.new(items: items)
    end

    it 'returns an object with data from the config file' do
      items = @header.items

      expect(items).to eq(
        {
          logo_alt: 'Sample Alt',
          logo_path: '/images/logos/sample-logo.png',
          name: 'Sample Name',
          sign_up_path: 'https://path/to/site',
          sign_up_text_arr: ['Log In', 'Try Me'],
          subtitle: 'Sample Subtitle',
          show_hiring_link: true,
        }
      )
    end
  end

  describe '#header_from_config with no config file' do
    it 'raises an exception' do
      allow_any_instance_of(described_class).to receive(:config_exist?).with(path).and_return(false)

      expect { described_class.new }.to raise_error(RuntimeError, 'You must provide a config/business_info.yml file in your documentation path.')
    end
  end

  describe '#hiring_display' do
    subject { described_class.new.hiring_display(config) }

    context 'when set to true' do
      let('config') { { 'header' => { 'hiring' => { 'display' => true } } } }

      it { expect(subject).to eq(true) }
    end

    context 'when set to false' do
      let('config') { { 'header' => { 'hiring' => { 'display' => false } } } }

      it { expect(subject).to eq(false) }
    end

    context 'when key is missing' do
      let('config') { { 'header' => { 'hiring' => {} } } }

      it { expect { subject }.to raise_error(RuntimeError, 'You must provide a true or false value for the hiring display parameter inside the header section of the config/business_info.yml file') }
    end
  end
end
