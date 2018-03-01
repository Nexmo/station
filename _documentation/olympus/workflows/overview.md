---
title: Overview
---

# Overview

The Workflow API is an API allows you to combine multiple [Messages](/olympus/messages/overview) and provide failover between them.

* **Send and receive** SMS, Facebook and Viber Messages with Workflows built on-top of the the [Messages API](/olympus/messages/overview).
* **Failover** with Workflows when messages can't be delivered.

## Contents

In this document you can learn about:

* [Concepts](#concepts)
* [How to Get Started with Olympus](#getting-started)
* [Building Blocks](#building-blocks)
* [Guides](#guides)
* [Reference](#reference)

## Concepts

To use Workflows API, you may need to familiarise yourself with:

* **[Authentication](/concepts/guides/authentication)** - The Workflows API is authenticated with JWT.
* **[Messages](/olympus/messages/overview)** - The Messages API is used for sending messages to a single channel.
* **[Workflows](/olympus/workflows/overview)** - The Workflow API is used to combine messages together with logic to allow for failover.

## Getting Started

### Configure your Devlivery Receipt and Inbound Message endpoint with Nexmo

From [Nexmo Dashboard](https://dashboard.nexmo.com) go to [Settings](https://dashboard.nexmo.com/settings).

Set the HTTP Method to POST and enter your endpoint in the fields labeled **Webhook URL for Inbound Message** and **Webhook URL for Delivery Receipt**:

```screenshot
script: app/screenshots/webhook-url-for-inbound-message.js
image: public/assets/screenshots/1b9047ceebd9312df0a3be8202be342c4da70201.png
```

### Send a message with failover

Sending an message that failsover to another channel is straightforward. In this example we will send a Viber message that failsover to SMS. Sign up for an account and replace the following variables in the example below:

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
config: 'olympus.workflows.send-failover-sms-viber'
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
