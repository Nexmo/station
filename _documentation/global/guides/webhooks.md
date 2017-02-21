---
title: Webhooks
description: How to set and use webhook endpoints for the Nexmo APIs.
---

#Webhooks

Information resulting from requests to the SMS API, Voice API, Number Insight API, US Short Codes API and Nexmo virtual numbers is sent in an HTTP request to your [webhook](https://en.wikipedia.org/wiki/Webhook target) endpoint on an HTTP server.

![Callback workflow](/assets/images/workflow_callbacks.svg)

Nexmo sends and retrieves the following information using webhooks:

* SMS API - sends the delivery status of your message and receives inbound SMS
* Voice API - retrieves the [Nexmo Call Control Objects](voice/voice-api/nexmo-call-control-objects) you use to control the call from one webhook endpoint, and sends information about the call status to another
* Number Insight Advanced API - receives complete information about a phone number
* US Short Codes API - sends the delivery status of your message and receives inbound sms

This section explains

* [Setting the webhook endpoint for the Nexmo APIs](#setting)
* [Working with the Nexmo webhooks ](#interact)
* [Configuring your firewall ](#configuring)

##Setting the webhook endpoint for the Nexmo APIs

You set the your webhook endpoint either in Dashboard or through the API. The hierarchy for these calls is:

* Account - using the *Settings* in [Dashboard](https://dashboard.nexmo.com  target), set the webhook endpoint that handles [Inbound Messages](messaging/sms-api/api-reference#inbound) and [Delivery Receipts](messaging/sms-api/api-reference#delivery_receipt). These webhooks also handle [US Short Codes API](messaging/us-short-codes-api).
* Virtual Number - using the Number settings in [Dashboard](https://dashboard.nexmo.com target) set the webhook endpoints associated with each virtual number you rent.
* App - use the [Application API](tools/application-api) to set or update the default webhook endpoints for all communication with this app.
* Request - using the request parameters set the webhook endpoint for each request.
* NCCO - for Voice API, set the webhook endpoints used for each action in the NCCO stack

By default, all connections to your webhook endpoints use a GET request. Use the request parameters to reception POST requests. For GET requests, values are sent in parameters appended to the URL. For POST requests these values are sent in the request body.

The following table shows how to set the webhook endpoint for the Nexmo APIs:

API | Request and return parameters
-- | --
Application API | Set or update the answer_url parameter used to retrieve NCCOs and the event_url parameter used to send call status information. <ul><li>[POST `https://api.nexmo.com/v1/applications`](tools/application-api/api-reference#create)</li><li>[PUT `https://api.nexmo.com/v1/applications/{app_uuid}`](tools/application-api/api-reference#update)</li></ul></ul>
Call API<br>**Note**: this API is deprecated, use [Voice API](voice/voice-api) | Send information about the Call to this endpoint when the Call is terminated. <ul><li>[status_url](voice/voice-deprecated/call/request#status_url)</li><li>[return parameters](voice/voice-deprecated/call/status-codes)</li></ul>  
&nbsp; | Nexmo retrieves the [VoiceXML](voice/voice-deprecated/call/voice-xml) that controls your Call from this endpoint when the Call is answered. <ul><li>[answer_url](voice/voice-deprecated/call/request#answer_url)</li></ul>
&nbsp; | Retrieve the [VoiceXML](voice/voice-deprecated/call/voice-xml) that controls the call if an error occurs either requesting or executing your VoiceXML from this endpoint.  <ul><li>[error_url](voice/voice-deprecated/call/request#error_url)</li></ul>|
Developer API | Developer API does not use webhooks.
<a name="ncco"></a>NCCO |  The webhooks endpoints you set in an NCCO receive data about an action: <ul><li>[record.eventUrl](voice/voice-api/ncco-reference#record) - set the webhook endpoint that receives information about the recording for a Call or Conversation</li><li>[conversation.eventUrl](voice/voice-api/ncco-reference#conversation) - set the URL to the webhook endpoint Nexmo calls asynchronously when a conversation changes state for this conversation action</li><li>[connect.eventUrl](voice/voice-api/ncco-reference#connect) - set the URL to the webhook endpoint Nexmo calls asynchronously when a conversation changes state for this connect action</li><li>[input.eventUrl](voice/voice-api/ncco-reference#input) - set the URL to the webhook endpoint Nexmo sends the digits pressed by the callee</li><li>[stream.streamUrl](voice/voice-api/ncco-reference#stream) - set an array of URLS  pointing to the webhook endpoints hosting the audio file to stream to the Call or Conversation</li></ul> |
Number Insight Advanced API  | Send information about this *request* to [callback](number-insight/advanced-async/api-reference#callback) in a single callback. <ul><li>[callback ](number-insight/advanced-async/api-reference#callback) </li><li>[return parameters ](number-insight/advanced-async/api-reference#ni-return-parameters ) </li></ul>  
SMS API | Send the delivery receipt to this endpoint. <ul><li>[callback](messaging/sms-api/api-reference#callback)</li><li>[DLR ](messaging/sms-api/api-reference#delivery_receipt) </li></ul>  
&nbsp; | Send inbound messages to this endpoint. <ul><li>In https://dashboard.nexmo.com/your-numbers: <ol><li>Click *edit* for the virtual number.</li><li>Set *Callback URL* and click *Update*.</li></ol></li><li>[DLR ](messaging/sms-api/api-reference#delivery_receipt)</li></ul>
Text-To-Speech API <br>**Note**: this API is deprecated, use [Voice API](voice/voice-api) |Send information about the TTS to this endpoint when the TTS is terminated. <ul><li>[callback ](voice/voice-deprecated/text-to-speech/request#callback)</li><li>[return parameters ](voice/voice-deprecated/text-to-speech/status-codes) </li></ul>
<span style="white-space:nowrap;">Text-To-Speech Prompt API</span> <br>**Note**: this API is deprecated, use [Voice API](voice/voice-api)| Send information about the TTS Prompt to this endpoint when the TTS Prompt is terminated. <ul><li>[callback ](voice/voice-deprecated/text-to-speech-prompt/request#callback)</li><li>[return parameters ](voice/voice-deprecated/text-to-speech-prompt/status-codes ) </li></ul>
Verify API | Verify API does not use webhooks.
<span style="white-space:nowrap;">US Short Codes API</span> | Uses the same webhook endpoints as the SMS API.
Voice API | For an individual call, set the answer_url parameter used to retrieve NCCOs and the event_url parameter used to send call status information. <ul><li> [POST `https://api.nexmo.com/v1/calls`](voice/voice-api/api-reference#call_create) </li></ul> **Note**: you set the default webhook endpoints for all calls with the [Application API](#application_api), you set the webhook endpoints for individual actions in a call using  [NCCO](#ncco)s. |


##Working with the Nexmo webhooks

To interact with Nexmo webhooks:

1. You:

    1. Create a Nexmo account.
    2. Write scripts to handle the information sent or requested by Nexmo. Your scripts must always respond with HTTP 200 to inbound messages from Nexmo.
    3. Put your scripts on your HTTP server.
    4. Send a *request* with the [webhook endpoint](#setting) set.

2. Information about your request is sent to your webhook endpoint.

The following code examples are webhooks for the SMS API:

```tabbed_examples
source: '_examples/messaging/webhooks/inbound'
```

##Configuring your firewall
If you restrict inbound traffic (including delivery receipts), you need to whitelist the following IP addresses in your firewall. Inbound traffic from Nexmo might come from any of the following:

* `174.37.245.32/29`
* `174.36.197.192/28`
* `173.193.199.16/28`
* `119.81.44.0/28`

----
Description:
