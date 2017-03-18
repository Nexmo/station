require 'dotenv'

Dotenv.load

API_KEY = ENV['API_KEY']
API_SECRET = ENV['API_SECRET']
APPLICATION_ID = ENV['APPLICATION_ID']
PRIVATE_KEY = ENV['PRIVATE_KEY']
FROM_NUMBER = ENV['FROM_NUMBER']
TO_NUMBER = ENV['TO_NUMBER']

require 'nexmo'

client = Nexmo::Client.new(
  key: API_KEY,
  secret: API_SECRET,
  application_id: APPLICATION_ID,
  private_key: File.read(PRIVATE_KEY)
)

response = client.create_call(
  from: { type: 'phone', number: FROM_NUMBER },
  to: [{ type: 'phone', number: TO_NUMBER }],
  answer_url: [
    'https://nexmo-community.github.io/ncco-examples/first_call_talk.json'
  ]
)

puts response
