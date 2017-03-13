---
title: Receiving an SMS
navigation_weight: 2
---

# Receiving an SMS

With Nexmo API you can receive SMS messages on your virtual numbers.

## Buy a number

Log into your Nexmo account and go to [Numbers > Buy numbers](https://dashboard.nexmo.com/buy-numbers) here you should buy any number with SMS capabilities.

> Note: You can also buy numbers with Nexmo CLI. Run `nexmo help` to see how.

## Configure the webhook

Go to [Numbers > Your Numbers](https://dashboard.nexmo.com/your-numbers) in the dashboard and press `edit` next to the number you wish to receive SMS on.

Enter the URL for Nexmo to make a request to when an SMS is received and then press update.

![Manage your numbers webhook](/assets/images/numbers/webhooks/manage.png)

## Payload

When a message is received on your number you will receive a [GET] request on the specified Webhook URL. Below you can find an example of what to expect in the payload.

**URL Parameters**

Parameter | Description | Type | Example
-- | -- | -- | --
`msisdn` | The number that the message originated from | `string` | `447700900000`
`to` | The number that the message was sent to | `string` | `447700900000`
`messageId` | A sixteen character long message ID string. | `string` | `0A12345678BC90D`
`text` | The body of the message | `string` | `Hello Nexmo!`
`message-timestamp` | The timestamp that the message was received | `string` (`ISO 8601`) | `2020-01-01 12:00:00`

**Headers**

Key | Value
-- | --
`Accept` | `*/*`
`User-Agent` | `Nexmo/MessagingHUB/v1.0`
