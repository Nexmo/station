require 'rails_helper'

RSpec.describe 'static/profile.html.erb' do
  let(:author) { Blog::Author.new({'name' => 'John Doe', 'title' => 'Developer Advocate', 'short_name' => 'john-doe'}) }

  it 'renders the profile' do
    render partial: 'static/profile.html.erb', locals: { member: author }

    view = Capybara::Node::Simple.new(rendered)

    expect(view).to have_css('h3', text: 'John Doe')
    expect(view).to have_css('p', text: 'Developer Advocate')
    expect(view).to have_css('svg')
    expect(view).to have_css('a', id: 'blog-profile-url')
    expect(view).to have_link(href: '/blog/authors/john-doe')
  end
end
