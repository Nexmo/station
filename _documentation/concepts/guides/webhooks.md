---
title: Webhooks
description: How to set and use webhook endpoints for the Nexmo APIs.
---

# Webhooks

## What is a webhook?

A [webhook](https://en.wikipedia.org/wiki/Webhook) is a callback sent via HTTP to a URL of your choice. It is a simple way of enabling communication from our servers to yours. Nexmo uses webhooks to notify you about incoming calls and messages, events in calls and delivery receipts for messages.

## Which APIs support webhooks?

Information resulting from requests to the SMS API, Voice API, Number Insight API, US Short Codes API and Nexmo virtual numbers is sent in an HTTP request to your webhook endpoint on an HTTP server.

Nexmo sends and retrieves the following information using webhooks:

* SMS API - sends the delivery status of your message and receives inbound SMS
* Voice API - retrieves the [Nexmo Call Control Objects](/voice/guides/ncco) you use to control the call from one webhook endpoint, and sends information about the call status to another
* Number Insight Advanced Async API - receives complete information about a phone number
* US Short Codes API - sends the delivery status of your message and receives inbound SMS

## Setting the webhook endpoint for the Nexmo APIs

You can set the your webhook endpoint either in Dashboard or through the API. The hierarchy for these calls is:

1. Account - using the *Settings* in [Dashboard](https://dashboard.nexmo.com), set the webhook endpoint that handles [Inbound Messages](/api/sms#inbound) and [Delivery Receipts](/api/sms#delivery_receipt). These webhooks also handle [US Short Codes API](/messaging/us-short-codes/overview).
2. Virtual Number - using the Number settings in [Dashboard](https://dashboard.nexmo.com) set the webhook endpoints associated with each virtual number you rent.
3. App - use the [Application API](/concepts/guides/applications) to set or update the default webhook endpoints for all communication with this app.
4. Request - using the request parameters set the webhook endpoint for each request.
5. NCCO - for Voice API, set the webhook endpoints used for each action in the NCCO stack

By default, requests made to your webhook endpoints use `GET`. You can change this to `POST` in the [Dashboard](https://dashboard.nexmo.com). For `GET` requests, values are sent in parameters appended to the URL. For `POST` requests these values are sent in the request body.

The following table shows how to set the webhook endpoint for the Nexmo APIs:

```tabbed_content
source: '_examples/concepts/guides/webhooks-setup/'
```

## Working with the Nexmo webhooks

To interact with Nexmo webhooks:

1. Create a Nexmo account.
2. Write scripts to handle the information sent or requested by Nexmo. Your scripts must always respond with HTTP 200 to inbound messages from Nexmo.
3. Put your scripts on your HTTP server.
4. Send a *request* with the [webhook endpoint](#setting) set.

Information about your request is then sent to your webhook endpoint.

The following code examples are webhooks for the SMS API:

```tabbed_examples
source: '_examples/messaging/webhooks/inbound'
```

## Configuring your firewall
If you restrict inbound traffic (including delivery receipts), you need to whitelist the following IP addresses in your firewall. Inbound traffic from Nexmo might come from any of the following:

* `174.37.245.32/29`
* `174.36.197.192/28`
* `173.193.199.16/28`
* `119.81.44.0/28`
