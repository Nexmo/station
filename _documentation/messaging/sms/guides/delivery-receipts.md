---
title: Delivery receipts
---

# Delivery receipts

When you make a successful request to the SMS API, it returns an array of `message` objects, one for each message. Ideally these will have a `status` of `0`, indicating success. But this does not mean that your message has reached your recipients. It only means that your message has been successfully queued for sending.

Nexmo's [adaptive routing](https://help.nexmo.com/hc/en-us/articles/218435987-What-is-Nexmo-Adaptive-Routing-) then identifies the best carrier for your message. When the selected carrier has delivered the message, it returns a *delivery receipt* (DLR). To receive DLRs in your application, you must provide a [webhook](/concepts/guides/webhooks) for Nexmo to send them to.

This guide contains the following:

* [How delivery receipts work](#how-delivery-receipts-work)
* [Handling delivery receipts](#handling-delivery-receipts)
* [Understanding the delivery receipt](#understanding-the-delivery-receipt)
* [Using the SMS API in campaigns](#using-the-sms-api-in-campaigns)
* [Links to other resources](#other-resources)

> **Note**: A DLR does not guarantee that a message has reached its target. See [how delivery receipts work](#how-delivery-receipts-work).

## How delivery receipts work

```js_sequence_diagram
participant Your Application
participant Nexmo
participant Carrier
participant Handset

Your Application->Nexmo: Send an SMS
Nexmo->Carrier: SMS
Carrier->Handset: SMS
Handset->Carrier: Delivery Receipt
Carrier->Nexmo: Delivery Receipt
Nexmo->Your Application: Delivery Receipt Webhook
```

Delivery receipts are either:

* **Carrier** - returned when the service provider receives the message
* **Handset** - returned when the user's handset receives the message

Not all DLRs guarantee that the target received your message. Some delivery receipts represent successful completion of just one stage in the delivery process, such as passing the message to another operator. Other delivery receipts are fakes. Because of this, Nexmo cannot completely guarantee that a DLR is accurate. It depends on the [countries](/messaging/sms/guides/country-specific-features) you are sending messages to and the providers involved.

If your message is longer than can be sent in a single SMS, the messages are [concatenated](/messaging/sms/guides/concatenation-and-encoding). You should receive a carrier DLR for each part of the concatenated SMS. Handset DLRs for a concatenated message are delayed. This is because the target handset has to process each part of the concatenated message before it can acknowledge receipt of the full message.

## Handling delivery receipts

To receive DLRs in your application, you must implement a webhook endpoint that Nexmo's API can send the payload to. This endpoint must be accessible via the public Internet.

### Make your machine publicly available

If you are running the code above on your desktop/laptop computer, you will need to make your computer publicly available so Nexmo can send the delivery receipt to it. An easy way to achive this is by using [ngrok](https://ngrok.com). See [this blog post](https://www.nexmo.com/blog/2017/07/04/local-development-nexmo-ngrok-tunnel-dr/) to learn how to use `ngrok`.

### Create your webhook

Create your webhook using your chosen Nexmo REST API client library:

```building_blocks
source: '/messaging/sms/building-blocks/delivery-receipt'
```

### Tell Nexmo about your webhook

Once your webhook is running, you need to provide Nexmo with its URL so that the API can send delivery receipts to it.

The webhook URL is the domain name of your application or the one provided by `ngrok`, combined with the path to your webhook endpoint. For example: `https://demo.ngrok.io/webhooks/delivery-receipt`.

Paste your webhook URL into the [settings section of Nexmo Dashboard](https://dashboard.nexmo.com/settings)
in the field marked labelled "Webhook URL for Delivery Receipt" and press "Save Changes".

```screenshot
script: app/screenshots/webhook-url-for-delivery-receipt.js
image: public/assets/screenshots/smsDeliveryReceiptsWebhook.png
```
### Send a message and capture the receipt

You can now test your delivery receipt webhook by sending a message. Either use your chosen REST client library, or the [Nexmo CLI](/tools).

To send a message with the Nexmo CLI, enter the following:

```
$ nexmo sms 447700900000 "A text message sent using the Nexmo SMS API"
```

Shortly after sending your message, Nexmo will notify your server about any delivery receipts and display their contents in the console: 

```json
{
	"err-code": "0",
	"message-timestamp": "2018-10-25 12:10:26",
	"messageId": "0B00000127FDBC63",
	"msisdn": "447547232824",
	"network-code": "23410",
	"price": "0.03330000",
	"scts": "1810251210",
	"status": "accepted",
	"to": "Nexmo CLI"
}

{
  "err-code": "0",
  "message-timestamp": "2018-10-25 12:10:29",
  "messageId": "0B00000127FDBC63",
  "msisdn": "447547232824",
  "network-code": "23410",
  "price": "0.03330000",
  "scts": "1810251310",
  "status": "delivered",
  "to": "Nexmo CLI"
}
```

## Understanding the delivery receipt

The `status` field in the DLR tells you if your SMS was delivered successfully. Possible values are:

| `status`  | Description  |
|---|---|
| `accepted` | Message has been accepted for delivery, but has not yet been delivered |
| `delivered`  | Message has been delivered  |
| `buffered` | Message has been buffered for later delivery  |
| `expired`  | Message was held at downstream carrier's retry scheme and could not be delivered within the expiry time |
| `failed` | Message not delivered |
| `rejected` | Downstream carrier refuses to deliver message |
| `unknown`  | No useful information available |

If the `err-code` is non-zero then your message failed. See the [Knowledge Base article](https://help.nexmo.com/hc/en-us/articles/204014733) for error code descriptions.

The other fields in the DLR are explained in the [API Reference](/api/sms#delivery-receipt).

## Using the SMS API in campaigns

Before you start your messaging campaign, check the [country specific features guide](/messaging/sms/guides/country-specific-features) for the countries you are sending to. If the country you are sending to does not supply reliable DLRs, use the [Conversion API](/messaging/conversion-api/overview) to provide Nexmo with more data points and ensure the best routing.

Optionally, you can identify specific customers or campaigns by including a reference with each message you send. These are included in the delivery receipt. Pass your chosen reference into the request by specifying a `client-ref` parameter of up to 40 characters.

## Other resources

* [Webhooks Guide](/concepts/guides/webhooks) — a detailed guide to how to use webhooks with Nexmo's platform
* [Why was my SMS not delivered?](https://help.nexmo.com/hc/en-us/articles/204016013-Why-was-my-SMS-not-delivered-) - useful troubleshooting tips
* [Receiving SMS delivery receipts with PHP](https://www.nexmo.com/blog/2018/06/25/receiving-sms-delivery-receipts-with-php-dr/) - blog post
* [How to receive an SMS delivery receipt from a mobile carrier with Ruby on Rails](https://www.nexmo.com/blog/2017/10/19/receive-sms-delivery-receipt-ruby-on-rails-dr/) - blog post
* [Creating a delivery receipt web hook](/messaging/sms/building-blocks) - code samples
* [Sending an SMS](/messaging/sms/building-blocks/send-an-sms) - code samples
