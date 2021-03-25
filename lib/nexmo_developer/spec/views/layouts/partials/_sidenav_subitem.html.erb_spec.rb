require 'rails_helper'

RSpec.describe 'sidenva_subitem', type: :view do
  let(:folder) do
    { title: 'subaccounts', path: '_documentation/en/account/subaccounts', children: [] }
  end
  let(:subitem) { SidenavSubitem.new(folder: folder, sidenav: double(Sidenav)) }

  it 'renders the corresponding label' do
    render partial: '/layouts/partials/sidenav_subitem.html.erb', locals: { sidenav_subitem: subitem }

    expect(Capybara::Node::Simple.new(rendered)).to have_css('.Vlt-badge--green', text: 'Beta')
  end
end
