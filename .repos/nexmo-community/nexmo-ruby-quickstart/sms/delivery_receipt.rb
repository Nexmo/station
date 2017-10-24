require 'sinatra'
require 'json'

set :port, ENV['PORT'] || 5000

get '/delivery-receipt' do
  puts params
  status 200
end

post '/delivery-receipt' do
  puts JSON.parse(request.body.read)
  status 200
end
