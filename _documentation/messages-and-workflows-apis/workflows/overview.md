---
title: Overview
---

# Workflows Overview [Developer Preview]

The Workflows API allows you to combine [messages](/messages-and-workflows-apis/messages/overview) sent via multiple channels and provides failover between them. This enables you to attempt to send a message to a user via Facebook or Viber, and then fall back to sending via SMS if the user does not receive or read the first message. Trying Facebook and Viber first allows you to provide a richer experience to the user including images and potentially to save money on SMS charges.

* **Send** SMS, Facebook Messenger and Viber Service Messages with Workflows built on-top of the the [Messages API](/messages-and-workflows-apis/messages/overview).
* **Failover** to the next message if the success condition is not met within the time period or if the message immediately fails.

The success condition is the status that the message returns. With Facebook Messenger and Viber Service Messages, you can use `delivered` and `read` statuses as the success condition. With SMS you can only use `delivered`.

There may be bugs and quirks so we'd welcome your feedback - any suggestions you make help us shape the product. If you do need help, please email [support@nexmo.com](mailto:support@nexmo.com) and include Workflows API in the subject line. Please note that during the Developer Preview period support times are limited to Monday to Friday.

## Contents

* [Concepts](#concepts)
* [How to Get Started with Workflows](#getting-started)
* [Building Blocks](#building-blocks)
* [Guides](#guides)
* [Reference](#reference)

## Concepts

To use Workflows API, you may need to familiarise yourself with:

* **[Authentication](/concepts/guides/authentication)** - The Workflows API is authenticated with JWT.
* **[Messages](/messages-and-workflows-apis/messages/overview)** - The Messages API is used for sending messages to a single channel.

## Building Blocks

* [Send a message with failover](/messages-and-workflows-apis/workflows/building-blocks/send-a-message-with-failover): the core details of how to use the Workflows API for sending messages with failover

## Guides

* [Failover](/messages-and-workflows-apis/workflows/guides/failover): how to set up your account and environment to send a message using Viber with fallback to SMS

## Reference

* [Messages API Reference](/api/messages-and-workflows-apis/messages)
* [Workflows API Reference](/api/messages-and-workflows-apis/workflows)
