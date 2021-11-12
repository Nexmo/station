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

  describe '#sign_up_path' do
    subject { described_class.new.sign_up_path }

    it { expect(subject).to eq('https://path/to/site') }
  end

  describe '#sign_up_text' do
    subject { described_class.new.sign_up_text }

    it { expect(subject).to eq(['Log In', 'Try Me']) }
  end

  describe '#sign_in_path' do
    subject { described_class.new.sign_in_path }

    it { expect(subject).to eq('https://path/to/site') }
  end

  describe '#sign_in_text' do
    subject { described_class.new.sign_in_text }

    it { expect(subject).to eq('Sign in') }
  end
end
