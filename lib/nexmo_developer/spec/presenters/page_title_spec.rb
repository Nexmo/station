require 'rails_helper'

RSpec.describe PageTitle, type: :model do
  let(:product) { nil }

  subject { described_class.new(product, title) }

  describe '#title' do
    context 'with title' do
      let(:title) { 'Metadata Example Title' }

      context 'with product' do
        let(:product) { 'example/example-api' }

        it 'returns the product and title with the default appended' do
          allow_any_instance_of(PageTitle).to receive(:load_config).and_return(sample_config)
          expect(subject.title).to eq('Example API > Metadata Example Title | Vonage API Developer')
        end
      end

      context 'without one' do
        it 'returns the title with the default appended' do
          expect(subject.title).to eq('Metadata Example Title | Vonage API Developer')
        end
      end
    end

    context 'without title' do
      let(:title) { nil }

      it 'returns the default' do
        expect(subject.title).to eq('Vonage API Developer')
      end
    end
  end

  def sample_config
    {
      'products' => [
        {
          'name' => 'Example API',
          'icon' => 'user',
          'icon_colour' => 'purple-dark',
          'path' => 'example/example-api',
          'dropdown' => true,
        },
      ],
    }
  end
end
