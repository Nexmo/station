require 'rails_helper'

RSpec.describe Redirector do
  it 'returns a redirected path' do
    request = OpenStruct.new(path: '/sms')
    expect(Redirector.find(request)).to eq('/messaging/sms/overview')
  end
end
