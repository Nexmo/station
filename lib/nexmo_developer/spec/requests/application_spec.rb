require 'rails_helper'

RSpec.describe 'Application', type: :request do
  describe 'redirect developer.nexmo*.com' do
    it '- redirect host: developer.nexmo.com' do
      host! 'developer.nexmo.com'
      get '/'
      expect(response).to have_http_status(:moved_permanently)
      expect(response).to redirect_to('https://developer.vonage.com/')
    end
    it '- redirect host: developer.nexmocn.com' do
      host! 'developer.nexmocn.com'
      get '/api-errors'
      expect(response).to have_http_status(:moved_permanently)
      expect(response).to redirect_to('https://developer.vonage.com/api-errors?locale=cn')
    end
    it '- redirect host: developer.nexmocn.com' do
      host! 'developer.nexmocn.com'
      get '/api-errors?test=test'
      expect(response).to have_http_status(:moved_permanently)
      expect(response).to redirect_to('https://developer.vonage.com/api-errors?test=test&locale=cn')
    end
    it '- do not redirect random domain' do
      host! 'developer.something.com'
      get '/'
      expect(response).to have_http_status(:success)
    end
  end
end
