require 'rails_helper'

RSpec.describe 'static/profile.html.erb' do
  it 'renders the profile' do
    render partial: 'static/profile.html.erb', locals: { name: 'John Doe', email: 'john.doe@vonage.com', blog_profile_url: '' }

    view = Capybara::Node::Simple.new(rendered)

    expect(view).to have_css('h3', text: 'John Doe')
    expect(view).to have_css('p', text: 'Developer Advocate')
    expect(view).to have_link('@vonagedevs', href: 'https://twitter.com/vonagedevs')
  end
end
