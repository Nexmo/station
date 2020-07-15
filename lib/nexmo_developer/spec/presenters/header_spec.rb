require 'rails_helper'

RSpec.describe Header do
  describe '#initialize' do
    it 'instantiates the presenter if the config file is present' do
      expect { described_class.new }.not_to raise_error
    end

    it 'raises if the config file is not present' do
      allow(Rails.configuration).to receive(:docs_base_path).and_return('~/invalid_path/')
      expect { described_class.new }
        .to raise_error(RuntimeError, 'You must provide a config/business_info.yml file in your documentation path.')
    end
  end

  describe '#logo_path' do
    subject { described_class.new.logo_path }

    it { expect(subject).to eq('/images/logos/sample-logo.png') }
  end

  describe '#small_logo_path' do
    subject { described_class.new.small_logo_path }

    it { expect(subject).to eq('/images/logos/Vonage-lettermark.svg') }
  end

  describe '#logo_alt' do
    subject { described_class.new.logo_alt }

    it { expect(subject).to eq('Sample Alt') }
  end

  describe '#name' do
    subject { described_class.new.name }

    it { expect(subject).to eq('Sample Name') }
  end

  describe '#subtitle' do
    subject { described_class.new.subtitle }

    it { expect(subject).to eq('Sample Subtitle') }
  end

  describe '#hiring_link?' do
    subject { described_class.new.hiring_link? }

    it { expect(subject).to eq(true) }

    context 'when hiring.display is missing' do
      let(:yaml) do
        <<~HEREDOC
          header:
            hiring:
        HEREDOC
      end

      it 'raises' do
        allow(File).to receive(:open).and_call_original
        allow(File).to receive(:open).and_return(yaml)
        expect { subject }.to raise_error(RuntimeError, 'You must provide a true or false value for the hiring display parameter inside the header section of the config/business_info.yml file')
      end
    end
  end

  describe '#sign_up_path' do
    subject { described_class.new.sign_up_path }

    it { expect(subject).to eq('https://path/to/site') }
  end

  describe '#sign_up_text' do
    subject { described_class.new.sign_up_text }

    it { expect(subject).to eq(['Log In', 'Try Me']) }
  end
end
