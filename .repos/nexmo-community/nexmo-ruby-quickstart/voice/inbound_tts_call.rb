require 'sinatra'
require 'json'

get '/call' do
  content_type :json
  [{
    action: "talk",
    text: "Hello world"
  }].to_json
end

post '/callback' do
  content_type :json
  if params != {}
    puts JSON.parse(request.body.read)
  end
  {}.to_json
end
