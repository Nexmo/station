require 'rails_helper'

RSpec.describe ApplicationController, type: :request do
  describe 'REDIRECT traffic' do
    it 'from developer.nexmo.com to developer.vonage.com' do
      host! 'developer.nexmo.com'

      get '/redirect_to_vonage'

      expect(request).to redirect_to(%r{\Ahttps://developer.vonage.com})

      expect(response.status).to eq(301)
    end
  end
end
