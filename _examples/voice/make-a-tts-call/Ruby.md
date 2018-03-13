---
title: Ruby
language: ruby
---

Install the Nexmo Ruby library

```bash
gem install nexmo
```

Create `app.rb`

```ruby
require 'nexmo'
PRIVATE_KEY = File.read(PRIVATE_KEY_PATH)

client = Nexmo::Client.new(
  application_id: APPLICATION_ID,
  private_key: PRIVATE_KEY
)

client.calls.create(
  from: { type: 'phone', number: FROM_NUMBER },
  to: [{ type: 'phone', number: TO_NUMBER }],
  answer_url: [
    'https://nexmo-community.github.io/ncco-examples/first_call_talk.json'
  ]
)
```

Run the application:

```bash
ruby app.rb
```
