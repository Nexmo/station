---
title: Ruby 
---

```ruby
require 'nexmo'

client = Nexmo::Client.new(key=API_KEY, secret=API_SECRET)
client.get_available_numbers('FR')
client.get_available_numbers('BR', features: "SMS"})
client.get_available_numbers('FR', pattern: "007", search_pattern: 1})
client.get_available_numbers('IT', params)
```