require 'rails_helper'

RSpec.feature 'Admin', type: :feature do
  context 'admin' do
    let(:admin) { FactoryBot.create(:user, admin: true) }

    background do
      visit '/admin'
      fill_in 'Email', with: admin.email
      fill_in 'Password', with: admin.password
      click_button 'Login'
    end

    scenario 'can access the feedback stats page' do
      visit '/stats'

      expect(page).to have_css('h1', text: 'Feedback Stats')
    end
  end
end
