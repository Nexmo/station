---
title: Overview
---

# Workflows Overview [Developer Preview]

The Workflows API allows you to combine [messages](/olympus/messages/overview) sent via multiple means, and provides failover between them. This enables you to attempt to send a message to a user via Facebook or Viber, and then fall back to sending via SMS if the user does not receive or read the first message. Trying Facbeook and Viber first allows you to provide a richer experience to the user including images.

* **Send** SMS, Facebook Messenger and Viber Service Messages with Workflows built on-top of the the [Messages API](/messages-and-workflows-apis/messages/overview).
* **Failover** to the next message if the success condition is not met within the time period or if the message immediately fails.

The success condition is the status that the message returns. With Facebook Messenger and Viber Service Messages, you can use `delivered` and `read` statuses as the success condition. With SMS you can only use `delivered`.

There may be bugs🐛 and quirks so we'd welcome your feedback - any suggestions you make help us shape the product. If you do need help, please email [support@nexmo.com](mailto:support@nexmo.com) and include Workflows API in the subject line. Please note that during the Developer Preview period support times are limited to Monday to Friday.

## Contents

In this document you can learn about:

* [Concepts](#concepts)
* [How to Get Started with Workflows](#getting-started)
* [Building Blocks](#building-blocks)
* [Guides](#guides)
* [Reference](#reference)

## Concepts

To use Workflows API, you may need to familiarise yourself with:

* **[Authentication](/concepts/guides/authentication)** - The Workflows API is authenticated with JWT.
* **[Messages](/messages-and-workflows-apis/messages/overview)** - The Messages API is used for sending messages to a single channel.

## Getting Started

### 1. Configure your Delivery Receipt and Inbound Message endpoint with Nexmo

From [Nexmo Dashboard](https://dashboard.nexmo.com), go to [Settings](https://dashboard.nexmo.com/settings).

Set the HTTP method to POST and enter your endpoint in the fields labeled **Webhook URL for Inbound Message** and **Webhook URL for Delivery Receipt**:

```screenshot
script: app/screenshots/webhook-url-for-inbound-message.js
image: public/assets/screenshots/dashboardSettings.png
```

For testing, you can use [requestb.in](https://requestb.in) to see the data passed to the webhooks.

### 2. Generate a JWT to Authenticate with Nexmo

As with the Messages API, the Workflows API authenticates using JWT.

In order to create a JWT for you Nexmo API key you will need to create a Nexmo Voice Application. This can be done under the [Voice tab](https://dashboard.nexmo.com/voice/create-application) or using the [Nexmo CLI]( https://github.com/Nexmo/nexmo-cli) tool.

You will be asked to provide an Event URL and an Answer URL when creating a Voice Application. These are currently only used by the Voice API and are ignored by the Messages and Workflows APIs. Instead the Messages API and Workflows API use the Delivery Receipt and Inbound Message URLs that you set in [Settings](https://dashboard.nexmo.com/settings).

Once you have created a Voice application you can use the application ID and private key to generate a JWT. There is more information on [Voice Application management]( https://www.nexmo.com/blog/2017/06/29/voice-application-management-easier/) and the use of [Nexmo libraries](https://developer.nexmo.com/tools).

If you're using the Nexmo CLI the command is:

```curl
$ JWT="$(nexmo jwt:generate /path/to/private.key \application_id=NEXMO_APPLICATION_ID)"
$ echo $JWT
```

### 3. Send a message with failover

Sending an message with failover to another channel is done by making one request to the Workflows API endpoint. In this example we will send a Facebook message that switches to SMS. Sign up for an account and replace the following variables in the example below:

Key | Description
-- | --
`NEXMO_APPLICATION_ID` |	The ID of the application that you created.
`FROM_NUMBER` | The phone number you are sending the message from in [E.164](https://en.wikipedia.org/wiki/E.164) format. For example `447700900000`.
`TO_NUMBER` | The phone number you are sending the message to in [E.164](https://en.wikipedia.org/wiki/E.164) format. For example `447700900000`.
`VIBER_SERVICE_MESSAGE_ID` | Your Viber Service Message ID. [Find out more](#).

| #### Prerequisites
|
| 1. [Rent a virtual number](/account/guides/numbers#rent-virtual-numbers)
|
| 2. [Create an application](/concepts/guides/applications#getting-started-with-applications)
|
| 3. Generate a JWT:
|
|     ```curl
|     $ JWT="$(nexmo jwt:generate /path/to/private.key \application_id=NEXMO_APPLICATION_ID)"
|     $ echo $JWT
|     ```

#### Example

```tabbed_examples
config: 'messages_and_workflows_apis.workflows.send-failover-sms-viber'
```

## Building Blocks

* [Send a message with failover](/messages-and-workflows-apis/workflows/building-blocks/send-a-message-with-failover)

## Guides

* [Facebook Messenger](/messages-and-workflows-apis/messages/guides/facebook-messenger)
* [Viber Service Messages](/messages-and-workflows-apis/messages/guides/viber-service-messages)

## Reference

* [Messages API Reference](/api/messages-and-workflows-apis/messages)
* [Workflows API Reference](/api/messages-and-workflows-apis/workflows)
