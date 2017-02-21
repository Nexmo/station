---
title: Overview
---

# Overview

You use the Conversion API to tell Nexmo about the reliability of your 2FA communication. Adding conversion data means that Nexmo delivers messages faster and more reliably.

Conversion data is confidential, Nexmo does not share it with third parties.

In order to identify the carriers who provide the best performance, Nexmo continually tests the routes used to deliver SMS and Voice. Using Adaptive Routing(™) Nexmo actively reroutes messages through different carrier routes and ensures optimum delivery for your messages. The route choice is made using millions of real-time conversion data points.

Message delivery indicators are:

* Delivery receipts - in most instances DLRs are indicative of handset delivery. Unfortunately, delivery receipts are not always a reliable measurement of SMS reception. Nexmo uses conversion data as our main quality measurement.
* Conversion data - by continuously sending a small amount of traffic to carriers, we see which route is performing best at a point in time and automatically reroute accordingly. This analysis is carried out every 5 mins using data points from the previous 15mins.

When you are implementing Conversion API you must differentiate between your [2FA](/messaging/sms/guides/global-messaging) traffic and other messages. For example, [Event Based Alerts](/messaging/sms/guides/us-short-codes/alerts) or marketing messages. To do this, use one [api_key](/api/conversion) to authenticate requests to Conversation API for 2FA traffic, and a different `api_key` for everything else.

> Note: to rapidly integrate 2FA into your app, use [Verify API](https://docs.nexmo.com/verify/api-reference) or [Verify SDK](https://docs.nexmo.com/verify/verify-sdk-for-android). The Conversion API is integrated seamlessly into Verify for fast and reliable delivery of your content.

The following figure shows the Conversion API workflow:

![Conversion API workflow](/assets/images/workflow_conversion_api.svg)

Access to the Conversion API is not enabled by default when you create your Nexmo account. To use Conversion API, you must first request access in an email to [support@nexmo.com](mailto:support@nexmo.com).

Once you have access, to use Conversion API:

1. Start a 2FA workflow using either:

    1. [SMS API](/messaging/sms/overview)
    2. [Text-to-Speech API](/voice/guides/text-to-speech)
    3. [Text-to-Speech Prompt API](https://docs.nexmo.com/voice/voice-deprecated/text-to-speech-prompt)

2. Nexmo sends a text or voice message to your user.

3. Your user replies to your message or verification request.

4. As soon as possible, send a Conversion API [request](/api/conversion#request) with information about the Call or Text-To-Speech identified by `message-id`. Nexmo uses your conversion data and internal information about `message-id` for Adaptive Routing.

    ```tabbed_examples
    source: '_examples/messaging/conversion-api/request'
    ```

5. Check the [Response](/api/conversion#response) telling you if your conversion data was received by Nexmo.

    ```tabbed_examples
    source: '_examples/messaging/conversion-api/response'
    ```
