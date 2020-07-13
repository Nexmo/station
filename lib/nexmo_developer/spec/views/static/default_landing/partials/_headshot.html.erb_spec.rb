require 'rails_helper'

RSpec.describe '_headshot' do
  let(:url) { 'https://john.doe/about' }
  let(:name) { 'John Doe' }
  let(:intro) { 'Short introduction...' }
  let(:img_src) { '/assets/images/voyagers/headshot.png' }
  let(:twitter) { nil }
  let(:github) { nil }
  let(:location) { nil }
  let(:local_assigns) do
    {
      'url' => url,
      'name' => name,
      'intro' => intro,
      'img_src' => img_src,
      'twitter' => twitter,
      'github' => github,
      'location' => location,
    }
  end

  subject do
    render partial: '/static/default_landing/partials/headshot.html.erb', locals: local_assigns
  end

  it 'renders' do
    html = Capybara::Node::Simple.new(subject)

    expect(html).to have_link(href: url)
    expect(html).to have_css('h3', text: name)
    expect(html).to have_css('p', text: intro)
    expect(html).to have_css("img[src='#{img_src}']")
  end

  context 'with social media' do
    let(:twitter) { 'VonageDev' }
    let(:github) { 'Nexmo' }
    let(:location) { 'Remote' }

    it 'renders' do
      html = Capybara::Node::Simple.new(subject)

      expect(html).to have_link("@#{twitter}", href: "https://twitter.com/#{twitter}")
      expect(html).to have_link(github, href: "https://github.com/#{github}")
      expect(html).to have_css('small', text: location)
    end
  end

  context 'when `url` is not provided' do
    let(:url) { nil }
    it { expect { subject }.to raise_error("Missing 'url' key in headshot landing page block") }
  end

  context 'when `name` is not provided' do
    let(:name) { nil }
    it { expect { subject }.to raise_error("Missing 'name' key in headshot landing page block") }
  end

  context 'when `intro` is not provided' do
    let(:intro) { nil }
    it { expect { subject }.to raise_error("Missing 'intro' key in headshot landing page block") }
  end
end
