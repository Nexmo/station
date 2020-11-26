require 'rails_helper'

RSpec.describe '/store', ndp: true do
  it 'redirects to https://apimanager.uc.vonage.com/store/' do
    get '/store'

    expect(response).to redirect_to('https://apimanager.uc.vonage.com/store/')
  end
end
