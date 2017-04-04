---
title: Receive a Delivery Receipt
navigation_weight: 3
---

# Receive a Delivery Receipt

## Implement a delivery receipt webhook

To get a delivery receipt we need to implement a webhook endpoint the API will send the payload to.

```tabbed_content
source: '_examples/messaging/sms/building-blocks/receive-a-delivery-receipt'
```

Run the script you have created.

## Make your machine publicly available

Your computer needs to be publicly available for Nexmo to send the payload to it. We recommend you try [Ngrok](https://ngrok.com) to do this quite easily.

```
$ ngrok http 5000

    ngrok by @inconshreveable                                                                                           (Ctrl+C to quit)

    Session Status                online
    Version                       2.1.18
    Region                        United States (us)
    Web Interface                 http://127.0.0.1:4040
    Forwarding                    http://0bae3e3a.ngrok.io -> localhost:5000
    Forwarding                    https://0bae3e3a.ngrok.io -> localhost:5000

    Connections                   ttl     opn     rt1     rt5     p50     p90
                                  0       0       0.00    0.00    0.00    0.00
```

## Tell Nexmo about your webhook endpoint

Now that your webhook endpoint is running, you need to tell Nexmo to send delivery receipts to this address.

The webhook URL is the forwarding address given to you by ngrok combined with `/delivery-receipt`.

For instance: `https://0bae3e3a.ngrok.io/delivery-receipt`

Paste your webhook URL into the [settings section of Nexmo Dashboard](https://dashboard.nexmo.com/settings)
in the field marked labelled "Webhook URL for Delivery Receipt" and press 'Save Changes'.

## Send a message

We are now ready to send the message, you can do this with the [Nexmo CLI](/tools) as such:

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

## See also

* [Webhooks Guide](/concepts/guides/webhooks) — a detailed guide to how to use webhooks with Nexmo's platform