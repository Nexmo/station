require 'sinatra'
require 'pp'

set :port, 5000

get '/delivery-receipt' do
  pp params

  status 200
end
