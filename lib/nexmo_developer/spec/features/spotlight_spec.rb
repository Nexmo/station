require 'rails_helper'

RSpec.feature 'Spotlight', ndp: true, js: true do
  background do
    allow(RestClient).to receive(:post).and_return(double(code: 200))
  end

  scenario 'submitting an idea' do
    visit '/spotlight'

    fill_in 'Your Name', with: 'John'
    fill_in 'Your Email Address', with: 'john@vonage.com'
    fill_in 'background', with: 'John\'s background...'
    fill_in 'outline', with: 'Outline of the idea'
    click_button 'Submit'

    expect(page).to have_css('#success .Vlt-callout__content', text: 'Thanks for your submission, we will review it and get in contact with you shortly')
  end
end
