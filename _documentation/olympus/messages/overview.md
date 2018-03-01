---
title: Overview
---

# Overview

The Messaging API is a single API that enables easy integration with various communication channels such as: SMS, Facebook Messenger and Viber.

This APIs is currently in Developer Preview and you will need to request access (link to access page) to use it.

During Developer Preview we will expand the capabilities of the API. Please visit the API Reference for a comprehensive breakdown and on high level we currently support:

* Outbound text messages on SMS, Viber Service Messages and Facebook Messenger.
* Outbound media messages on Facebook Messenger.
* Inbound text, media and location messages on Facebook Messenger. 

There may be bugs🐛 and quirks so we'd welcome your feedback-any suggestions you make help us shape the product.

## Contents

In this document you can learn about:

* [Concepts](#concepts)
* [How to Get Started with Olympus](#getting-started)
* [Building Blocks](#building-blocks)
* [Guides](#guides)
* [Reference](#reference)

## Concepts

To use the Messages API, you may need to familiarise yourself with:

* **[Authentication](/concepts/guides/authentication)** - The Messages API is authenticated with JWT.
* **[Workflows](/olympus/workflows/overview)** - The Workflow API is used to combine messages together with logic to allow for failover.

## Getting Started

## Configure your Devlivery Receipt and Inbound Message endpoint with Nexmo

From [Nexmo Dashboard](https://dashboard.nexmo.com) go to [Settings](https://dashboard.nexmo.com/settings).

Set the HTTP Method to POST and enter your endpoint in the fields labeled **Webhook URL for Inbound Message** and **Webhook URL for Delivery Receipt**:

```screenshot
script: app/screenshots/webhook-url-for-inbound-message.js
image: public/assets/screenshots/1b9047ceebd9312df0a3be8202be342c4da70201.png
```

### Send an SMS with Messages API

Sending an SMS message with the Messages API is straightforward. Sign up for an account and replace the following variables in the example below:

Key | Description
-- | --
`NEXMO_APPLICATION_ID` |	The ID of the application that you created.
`FROM_NUMBER` | The phone number you are sending the message from in [E.164](https://en.wikipedia.org/wiki/E.164) format. For example `447700900000`.
`TO_NUMBER` | The phone number you are sending the message to in [E.164](https://en.wikipedia.org/wiki/E.164) format. For example `447700900000`.

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
config: 'olympus.messages.send-sms'
```

## Building Blocks

* [Send an SMS with Messages API](/olympus/messages/building-blocks/send-an-sms-with-messages-api)
* [Send with Facebook Messenger](/olympus/messages/building-blocks/send-with-facebook-messenger)
* [Send a Viber Service Message](/olympus/messages/building-blocks/send-a-viber-service-message)
* [Send a message with failover](/olympus/workflows/building-blocks/send-a-message-with-failover)

## Guides

* [Facebook Messenger](/olympus/messages/guides/facebook-messenger)
* [Viber Service Messages](/olympus/messages/guides/viber-service-messages)

## Reference

* [Messages API Reference](/api/olympus/messages)
* [Workflows API Reference](/api/olympus/workflows)
