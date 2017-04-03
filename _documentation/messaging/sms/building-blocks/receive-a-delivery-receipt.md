---
title: Receive a Delivery Receipt
navigation_weight: 3
---

# Receive a Delivery Receipt

## Implement a delivery receipt webhook

To get a delivery receipt we need to implement the endpoint that the webhook will send the payload to.

```ruby
require 'sinatra'
require 'pp'

set :port, 3000

get '/delivery-receipt' do
  pp params
end
```

Then run the server with:

```
$ ruby app.rb
```

## Make your machine publicly available

You need your machine publicly available for Nexmo to send the payload to it. We reccomend you use [Ngrok](https://ngrok.com) to do this easily.

```
$ ngrok http 3000

    ngrok by @inconshreveable                                                                                           (Ctrl+C to quit)

    Session Status                online
    Version                       2.1.18
    Region                        United States (us)
    Web Interface                 http://127.0.0.1:4040
    Forwarding                    http://0bae3e3a.ngrok.io -> localhost:3000
    Forwarding                    https://0bae3e3a.ngrok.io -> localhost:3000

    Connections                   ttl     opn     rt1     rt5     p50     p90
                                  0       0       0.00    0.00    0.00    0.00
```

## Send a message

We're now ready to send the message, you can do this with the [Nexmo CLI](/tools) as such:

```
$ nexmo sms 447700900000 "This is a message from Nexmo API"
```

Shortly after your server should print the parameters:

```
{
  "msisdn"=>"447700900000",
  "to"=>"Nexmo CLI",
  "network-code"=>"12345",
  "messageId"=>"<REDACTED>",
  "price"=>"0.03330000",
  "status"=>"delivered",
  "scts"=>"1703291538",
  "err-code"=>"0",
  "message-timestamp"=>"2020-01-01 14:00:00"
}
```
