require 'rails_helper'

RSpec.describe UseCaseController, type: :controller do
  it 'renders' do
    get :index

    expect(response.status).to eq(200)
  end

  describe 'when a locale is present' do
    it 'redirects to the canonical url if locale is :en' do
      get :index, params: { locale: 'en' }

      expect(response).to redirect_to('/use-cases')
    end

    it 'renders when locale is different from :en' do
      get :index, params: { locale: 'cn' }

      expect(response.status).to eq(200)
    end
  end
end
