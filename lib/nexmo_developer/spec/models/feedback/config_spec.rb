require 'rails_helper'

RSpec.describe Feedback::Config do
  let(:config_file) do
    YAML.safe_load(
      File.read("#{Rails.configuration.docs_base_path}/config/feedback.yml")
    )
  end

  describe '.find_or_create_config' do
    context 'without an existing config' do
      it 'creates a new config' do
        described_class.find_or_create_config(config_file)
        expect(described_class).to have(1).records
      end
    end

    context 'with an existing config' do
      context 'different from the one provided' do
        let!(:existing) do
          described_class.create!(title: 'We love feedback!', paths: [])
        end

        it 'creates a new one' do
          expect(described_class.find_or_create_config(config_file)).not_to eq(existing)
          expect(described_class).to have(2).records
        end
      end

      context 'same as the one provided' do
        let!(:existing) do
          described_class.create!(
            title: config_file['title'],
            paths: config_file['paths']
          )
        end

        it 'returns the existing one' do
          expect(described_class.find_or_create_config(config_file)).to eq(existing)
          expect(described_class).to have(1).records
        end
      end
    end
  end
end
