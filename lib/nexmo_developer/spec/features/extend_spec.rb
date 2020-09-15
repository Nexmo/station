require 'rails_helper'

RSpec.feature 'Extend' do
  scenario 'visiting the Extend page', ndp: true do
    visit '/extend'

    expect(page).to have_css('h1', text: 'Extend')
    expect(page).to have_css('p', text: 'The Vonage API Extend Team develops productized integrations so builders everywhere can create better communication experiences for their users.')

    within('.Vlt-grid--center') do
      expect(page).to have_css('h5', text: 'Amazon Lex Connector')
      expect(page).to have_css('p', text: 'A hosted and opensource connector to bridge between Nexmo websockets and Amazon Lex')
      expect(page).to have_link('Learn More', href: '/extend/amazon-lex-connector')
    end
  end
end
