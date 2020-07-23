require 'rails_helper'

RSpec.describe Head do
  subject { described_class.new }

  before { allow(File).to receive(:exist?).and_call_original }

  describe '#initialize' do
    it 'instantiates the presenter if the config file is present' do
      expect { described_class.new }.not_to raise_error
    end

    it 'raises if the config file is not present' do
      allow(Rails.configuration).to receive(:docs_base_path).and_return('~/invalid_path/')
      expect { described_class.new }
        .to raise_error(RuntimeError, 'You must provide a config/header_meta.yml file in your documentation path.')
    end
  end

  describe '#title' do
    it { expect(subject.title).to eq('Vonage API Developer') }

    context 'when `title` is missing' do
      before do
        allow(YAML).to receive(:safe_load).and_return({})
      end

      it 'raises' do
        expect { subject.title }
          .to raise_error(RuntimeError, "You must provide a 'title' parameter in header_meta.yml")
      end
    end
  end

  describe '#description' do
    context 'without a frontmatter' do
      it { expect(subject.description).to eq('A Description') }

      context 'when `description` is missing' do
        before do
          allow(YAML).to receive(:safe_load).and_return({})
        end

        it 'raises' do
          expect { subject.description }
            .to raise_error(RuntimeError, "You must provide a 'description' parameter in header_meta.yml")
        end
      end
    end

    context 'a frontmatter takes precedence over the config file' do
      subject { described_class.new(frontmatter) }

      context 'with :meta_description' do
        let(:frontmatter) do
          { 'meta_description' => 'Meta description text' }
        end

        it { expect(subject.description).to eq('Meta description text') }
      end

      context 'with :description' do
        let(:frontmatter) do
          { 'description' => 'Description text' }
        end

        it { expect(subject.description).to eq('Description text') }
      end

      context 'with both' do
        let(:frontmatter) do
          {
            'description' => 'Description text',
            'meta_description' => 'Meta description text',
          }
        end

        it { expect(subject.description).to eq('Meta description text') }
      end
    end
  end

  describe '#google_site_verification' do
    it { expect(subject.google_site_verification).to eq('123456') }
  end

  describe '#application_name' do
    it { expect(subject.application_name).to eq('Vonage API Developer') }
  end

  describe '#favicon' do
    it { expect(subject.favicon).to eq('meta/favicon.ico') }

    context 'when the file is missing' do
      before do
        allow(File).to receive(:exist?)
          .with("#{Rails.configuration.docs_base_path}/public/meta/favicon.ico").and_return(false)
      end

      it 'raises' do
        expect { subject.favicon }
          .to raise_error(RuntimeError, 'You must provide an favicon.ico file inside the public/meta directory')
      end
    end
  end

  describe '#favicon_32_squared' do
    it { expect(subject.favicon_32_squared).to eq('meta/favicon-32x32.png') }

    context 'when the file is missing' do
      before do
        allow(File).to receive(:exist?)
          .with("#{Rails.configuration.docs_base_path}/public/meta/favicon-32x32.png").and_return(false)
      end

      it 'raises' do
        expect { subject.favicon_32_squared }
          .to raise_error(RuntimeError, 'You must provide an favicon-32x32.png file inside the public/meta directory')
      end
    end
  end

  describe '#manifest' do
    it { expect(subject.manifest).to eq('meta/manifest.json') }

    context 'when the file is missing' do
      before do
        allow(File).to receive(:exist?)
          .with("#{Rails.configuration.docs_base_path}/public/meta/manifest.json").and_return(false)
      end

      it 'raises' do
        expect { subject.manifest }
          .to raise_error(RuntimeError, 'You must provide an manifest.json file inside the public/meta directory')
      end
    end
  end

  describe '#safari_pinned_tab' do
    it { expect(subject.safari_pinned_tab).to eq('meta/safari-pinned-tab.svg') }

    context 'when the file is missing' do
      before do
        allow(File).to receive(:exist?)
          .with("#{Rails.configuration.docs_base_path}/public/meta/safari-pinned-tab.svg").and_return(false)
      end

      it 'raises' do
        expect { subject.safari_pinned_tab }
          .to raise_error(RuntimeError, 'You must provide an safari-pinned-tab.svg file inside the public/meta directory')
      end
    end
  end

  describe '#mstile_144_squared' do
    it { expect(subject.mstile_144_squared).to eq('meta/mstile-144x144.png') }

    context 'when the file is missing' do
      before do
        allow(File).to receive(:exist?)
          .with("#{Rails.configuration.docs_base_path}/public/meta/mstile-144x144.png").and_return(false)
      end

      it 'raises' do
        expect { subject.mstile_144_squared }
          .to raise_error(RuntimeError, 'You must provide an mstile-144x144.png file inside the public/meta directory')
      end
    end
  end

  describe '#apple_touch_icon' do
    it { expect(subject.apple_touch_icon).to eq('meta/apple-touch-icon.png') }

    context 'when the file is missing' do
      before do
        allow(File).to receive(:exist?)
          .with("#{Rails.configuration.docs_base_path}/public/meta/apple-touch-icon.png").and_return(false)
      end

      it 'raises' do
        expect { subject.apple_touch_icon }
          .to raise_error(RuntimeError, 'You must provide an apple-touch-icon.png file inside the public/meta directory')
      end
    end
  end

  describe '#og_image' do
    it { expect(subject.og_image).to eq('meta/nexmo-developer-card.png') }

    context 'when the file is missing' do
      before do
        allow(File).to receive(:exist?)
          .with("#{Rails.configuration.docs_base_path}/public/meta/nexmo-developer-card.png").and_return(false)
      end

      it 'raises' do
        expect { subject.og_image }
          .to raise_error(RuntimeError, 'You must provide an nexmo-developer-card.png file inside the public/meta directory')
      end
    end
  end

  describe '#og_image_width' do
    it { expect(subject.og_image_width).to eq(835) }
  end

  describe '#og_image_height' do
    it { expect(subject.og_image_height).to eq(437) }
  end
end
