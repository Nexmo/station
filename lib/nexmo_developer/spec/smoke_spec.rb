require 'rails_helper'

RSpec.describe 'Smoke Tests', type: :request do
  it '/contribute/overview contains the expected text' do
    get '/contribute/overview'
    expect(response.body).to include('We\'re always looking at ways to improve our documentation and platform and would love to invite you to contribute your suggestions not only to the content but also the open-source platform that it is built upon.')
  end

  it '/contribute/guides/writing-style-guide contains the expected text' do
    get '/contribute/guides/writing-style-guide'
    expect(response.body).to include('These are technical writing guidelines that can be used across all our technical documentation as well as blog posts.')
  end

  it '/product-lifecycle/beta contains the expected text' do
    get '/product-lifecycle/beta'
    expect(response.body).to include('Beta products at Vonage are in the final stages of testing')
  end
end
