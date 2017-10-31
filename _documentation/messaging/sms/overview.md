---
title: Overview
---

# Overview

Nexmo's SMS API allows you to send and receive text messages to users around the globe through simple RESTful APIs.

* Programmatically send and receive high volume of SMS anywhere in the world.
* Build apps that scale with the web technologies that you are already using.
* Send SMS with low latency and high delivery rates.
* Receive SMS for free using SMS-enabled local numbers in countries around the world.
* Only pay for what you use, nothing more.

## Contents

In this document you can learn about:

* [Nexmo SMS API Concepts](#concepts)
* [How to Get Started with the SMS API](#getting-started)
* [Building Blocks](#building-blocks)
* [Guides](#guides)
* [Tutorials](#tutorials)
* [Reference](#references)

## Prerequisites

To use the Nexmo SMS API, you may need to familiarise yourself with:

* **[Authentication](/concepts/guides/authentication)** - Nexmo SMS API is authenticated with your account API Key and Secret.

* **[Webhooks](/concepts/guides/webhooks)** - HTTP requests are made to your application web server so that you can act upon them. For example, the SMS API will send the delivery status of your message and receives inbound SMS.

## Getting Started

**Send an SMS**

Before you begin, [Sign up for a Nexmo account](https://dashboard.nexmo.com/sign-up).

Using your Nexmo `API_KEY` and `API_SECRET`, available from the [dashboard getting started page](https://dashboard.nexmo.com/getting-started-guide), you can now send an SMS message:

```techio
title: Send an SMS
path: /35772040f9cbf86b388ec61c0a004a3e1158/welcome/124993
```

## Building Blocks

* [Sending an SMS](/messaging/sms/building-blocks/send-an-sms)
* [Receiving an SMS](/messaging/sms/building-blocks/receiving-an-sms)

## Guides

* [Delivery Receipts](/messaging/sms/guides/delivery-receipts): how delivery receipts are produced and how to integrate them into your application
* [Custom Sender IDs](/messaging/sms/guides/custom-sender-ids): sending messages using an alphabetical identifier to match with your brand
* [Country Specific Features](/messaging/sms/guides/country-specific-features): what features are available in different countries
* [Concatenation](/messaging/sms/guides/concatenation): how multiple messages are concatenated to implement extended SMS
* [Encoding](/messaging/sms/guides/encoding): sending messages using different character sets
* [SMPP access](/messaging/sms/guides/SMPP-access): bulk sending messages via the SMPP protocol

## Tutorials

```tutorials
product: 'messaging/sms'
```

## Reference

* [SMS API Reference](/api/sms)
