require 'rails_helper'

RSpec.describe 'Admin pages', type: :feature do
  let(:admin) { FactoryBot.create(:user, admin: true) }

  before { sign_in admin }

  it 'can access the feedback stats page' do
    visit '/stats'

    expect(page).to have_css('h1', text: 'Feedback Stats')
  end

  it 'can access the code snippets coverage page' do
    visit '/coverage'

    expect(page).to have_css('h1', text: 'Code Snippet Stats')
  end
end
