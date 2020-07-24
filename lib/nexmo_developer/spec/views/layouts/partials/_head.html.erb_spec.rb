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
  end
end
