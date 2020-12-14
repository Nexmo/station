require 'rails_helper'

RSpec.describe 'head', type: :view do
  before do
    without_partial_double_verification do
      allow(view).to receive(:page_title).and_return('Title')
    end
  end

  subject { render partial: '/layouts/partials/head.html.erb' }

  describe "<meta name='description'" do
    it 'renders the meta_description' do
      expect(Capybara::Node::Simple.new(subject))
        .to have_css('meta[name="description"][content="A Description"]', visible: false)
    end

    context 'with a @frontmatter' do
      let(:frontmatter) do
        YAML.safe_load(
          File.read(
            "#{Rails.configuration.docs_base_path}/_documentation/en/messaging/sms/overview.md"
          )
        )
      end

      before { assign(:frontmatter, frontmatter) }

      it 'renders the meta_description from the frontmatter' do
        expect(Capybara::Node::Simple.new(subject))
          .to have_css('meta[name="description"][content="This documentation provides information on using the Nexmo SMS API for sending and receiving text messages."]', visible: false)
      end
    end
  end
end
