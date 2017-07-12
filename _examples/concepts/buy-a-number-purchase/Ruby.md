---
title: Ruby
language: ruby
---

```ruby
require 'nexmo'

client = Nexmo::Client.new(key=API_KEY, secret=API_SECRET)
client.buy_number(country: "GB", msisdn: "447700900000")
```
