---
title: Receiving an SMS
navigation_weight: 2
---

# Receiving an SMS

With Nexmo's SMS API you can receive SMS messages on your virtual numbers.

To receive SMS messages, you need to buy a number and setup an webhook endpoint.

## Buy a number

Log into the Nexmo dashboard and go to [Numbers > Buy numbers](https://dashboard.nexmo.com/buy-numbers).
Here you should buy a number with SMS capabilities.

You can also buy numbers with [Nexmo CLI](/tools/cli). Run `nexmo help` to see how.

> You may need to check [to see if features you need are available in the country
where you are buying a number](/messaging/sms/guides/global-messaging#country-specific-features).

## Implementing a webhook endpoint

To process incoming SMS messages, we will implement a webhook endpoint
with a lightweight backend framework.

```tabbed_content
source: '_examples/messaging/quickstarts/receiving-an-sms'
```

This will run locally. Your webhook endpoint needs to be accessible on the
public internet in order for Nexmo's servers to send messages to you. You can
do this easily using a service like [ngrok.com](https://ngrok.com/).

Once you have setup ngrok to tunnel messages to your local machine, you will
have a domain of the form `example1234.ngrok.com` - simply add the
endpoint defined in the Ruby code above to get your endpoint URL. The webhook URL will then be `http://example1234.ngrok.com/incoming-sms`

> Note: The Nexmo API expects a `200 OK` response. The code samples already
do this. If you return a different status code, the Nexmo SMS API will
repeatedly attempt to resend the message to your endpoint.

## Configure the webhook

Go to [Numbers > Your Numbers](https://dashboard.nexmo.com/your-numbers) in the dashboard and press `edit` next to the number you wish to receive SMS on.

Enter the URL for your webhook endpoint, then press update. Nexmo's API will send a request to this address for every an SMS is received.

![Manage your numbers webhook](/assets/images/numbers/webhooks/manage.png)

## Send a message to your number

From your mobile device, send a message to the number you bought from Nexmo. The server running your webhook should print a copy of your message to the terminal.

Now that the server works, you can change the behaviour of the webhook endpoint to do something more interesting (respond to messages, store messages in a database) etc.

## Payload

When a message is received on your number you will receive a [GET] request on the specified webhook URL.

Below you can find an example of what to expect in the payload.

## See also
