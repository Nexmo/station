require 'rails_helper'

RSpec.describe 'Product dropdown', type: :view do
  let(:locals) do
    {
      controller_name: :use_case,
      action_name: :index,
      product_scope: Nexmo::Markdown::UseCase.all,
    }
  end

  subject do
    render partial: '/layouts/partials/product_dropdown.html.erb', locals: locals
  end

  it 'scopes the products to :product_scope' do
    html = Capybara::Node::Simple.new(subject)

    expect(html).to have_css('.Vlt-dropdown__panel a', count: 2)
    expect(html).to have_link('Any Product', href: '/use-cases')
    expect(html).to have_link('Number Insight API', href: '/number-insight/use-cases')
  end
end
