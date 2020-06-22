require 'rails_helper'

RSpec.describe TopnavItem do
  let(:navigation) { :documentation }
  let(:url) { '/en/documentation' }
  let(:name) { 'documentation' }

  subject { described_class.new(name, url, navigation) }

  describe '#title' do
    it { expect(subject.title).to eq('Documentation') }
  end

  describe '#css_classes' do
    context 'when it is the active tab' do
      it { expect(subject.css_classes).to eq('Vlt-tabs__link Vlt-tabs__link_active') }
    end

    context 'otherwise' do
      let(:navigation) { :tools }
      it { expect(subject.css_classes).to eq('Vlt-tabs__link') }
    end
  end
end
