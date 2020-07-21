require 'rails_helper'

RSpec.describe LocaleSwitcherPresenter do
  let(:request) do
    double(controller_class: ApplicationController)
  end

  subject { described_class.new(request) }

  describe '#disabled?' do
    context 'when visiting /api pages' do
      let(:request) do
        double(controller_class: ActionDispatch::Request::PASS_NOT_FOUND)
      end

      it 'returns true' do
        expect(subject.disabled?).to eq(true)
      end
    end

    it 'returns false otherwise' do
      expect(subject.disabled?).to eq(false)
    end
  end

  describe '#current_locale' do
    context 'when locale set to :en' do
      it 'returns the corresponding text' do
        expect(I18n).to receive(:locale).and_return(:en)
        expect(subject.current_locale).to eq('English')
      end
    end

    context 'when locale set to :cn' do
      it 'returns the corresponding text' do
        expect(I18n).to receive(:locale).and_return(:cn)
        expect(subject.current_locale).to eq('简体中文')
      end
    end
  end

  describe '#locales' do
    it 'returns the available locales' do
      locales = subject.locales

      expect(locales.size).to eq(2)
      expect(locales.map(&:data)).to match_array(['en', 'cn'])
      expect(locales.map(&:value)).to match_array(['English', '简体中文'])
    end

    context 'with a reduced set of locales' do
      it 'returns the available locales' do
        expect(Dir).to receive(:[]).and_return(["#{Rails.configuration.docs_base_path}/_documentation/en"])

        locales = subject.locales

        expect(locales.size).to eq(1)
        expect(locales.map(&:data)).to match_array(['en'])
        expect(locales.map(&:value)).to match_array(['English'])
      end
    end
  end

  describe '#multiple_locales?' do
    context 'with multiple locales' do
      it 'returns true' do
        expect(Dir).to receive(:[]).and_return(
          [
            "#{Rails.configuration.docs_base_path}/_documentation/en",
            "#{Rails.configuration.docs_base_path}/_documentation/cn",
            "#{Rails.configuration.docs_base_path}/_documentation/ja",
          ]
        )

        expect(subject.multiple_locales?).to eq(true)
      end
    end

    context 'with one locale' do
      it 'returns false' do
        expect(Dir).to receive(:[]).and_return(["#{Rails.configuration.docs_base_path}/_documentation/en"])

        expect(subject.multiple_locales?).to eq(false)
      end
    end
  end
end
