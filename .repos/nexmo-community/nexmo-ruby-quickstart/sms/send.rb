require 'dotenv'
Dotenv.load

API_KEY = ENV['API_KEY']
API_SECRET = ENV['API_SECRET']
FROM_NUMBER = ENV['FROM_NUMBER']
TO_NUMBER = ENV['TO_NUMBER']

require 'nexmo'

client = Nexmo::Client.new(
  key: API_KEY,
  secret: API_SECRET
)

response = client.send_message(
  from: FROM_NUMBER,
  to: TO_NUMBER,
  text: 'Hello from Nexmo!'
)

puts response
