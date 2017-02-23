---
title: Overview
---

# Overview

With low latency and high deliverability, our SMS API is the most reliable way to reach users around the globe.

* Programmatically send and receive high volume of SMS anywhere in the world
* Build apps that scale with the web technologies that you are already using
* Send SMS with low latency and high delivery rates
* Receive SMS for free and tap into the worlds largest inventory of SMS-enabled numbers in real time.
* Only pay for what you use, nothing more.

## Contents

In this document you can learn about:

* [Nexmo SMS API Concepts](#concepts)
* [How to Get Started with the SMS API](#getting-started)
* [SMS API Features](#sms-api-features)
* [References](#references)
* [Tutorials](#tutorials)

## Concepts

* **Authentication** - Nexmo SMS API is authenticated with your account API Key and Secret. For more information on see [Authenticating](/api#authentication-information).

* **Webhooks** - HTTP requests are made to your application web server so that you can act upon them. For example, The SMS API will send the delivery status of your message and receives inbound SMS.

## Getting Started

**Send an SMS**

![SMS Workflow](/assets/images/workflow_call_api_outbound.svg)

Before you begin, [Sign up for a Nexmo account](https://dashboard.nexmo.com/sign-up).

Using your Nexmo `API_KEY` and `API_SECRET`, available from the [dashboard getting started page](https://dashboard.nexmo.com/getting-started-guide), you now send an SMS message:

```tabbed_examples
source: '/_examples/messaging/sending-an-sms/basic'
```

## SMS API Features

* [Sending an SMS](/messaging/sms/quickstarts/sending-an-sms)
* [Receiving an SMS](/messaging/sms/quickstarts/receiving-an-sms)

## References

* [SMS API Reference](/api/sms)

## Tutorials

* [Passwordless authentication](http://docs.nexmo.com/tutorials/verify-passwordless-login)
* [Two-factor authentication](http://docs.nexmo.com/tutorials/verify-two-factor-authentication)
* [Private SMS communication](http://docs.nexmo.com/tutorials/sms-api-proxy)
* [Mobile app invites](http://docs.nexmo.com/tutorials/mobile-app-promotion)
* [Two-way SMS for customer engagement](http://docs.nexmo.com/tutorials/two-way-notifications)
* [SMS Customer Support](http://docs.nexmo.com/tutorials/sms-customer-support)
