require 'rails_helper'

RSpec.describe 'Android docs', type: :request, ndp: true do
  context 'SDK reference' do
    it 'redirects to the proper path' do
      get '/client-sdk/sdk-documentation/android/android'

      expect(response).to redirect_to('/sdk/stitch/android/index')
    end

    it 'renders successsfully' do
      get '/sdk/stitch/android/index'

      expect(response).to have_http_status(:ok)
    end
  end

  context 'Release Notes' do
    it 'renders successsfully' do
      get '/client-sdk/sdk-documentation/android/release-notes'

      expect(response).to have_http_status(:ok)
    end
  end
end
