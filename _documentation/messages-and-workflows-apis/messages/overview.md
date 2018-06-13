---
title: Overview
navigation_weight: 1
---

# Overview

The Messages API provides integration with the following communications channels:

* SMS
* Facebook Messenger
* Viber

Currently the following features are supported:

* Outbound text messages on SMS, Viber Service Messages and Facebook Messenger.
* Outbound media messages on Facebook Messenger.
* Inbound text, media and location messages on Facebook Messenger.

## Developer Preview

This API is currently in Developer Preview and you will need to [request access](https://www.nexmo.com/products/messages) to use it.

Nexmo always welcomes your feedback. Your suggestions help us improve the product. If you do need help, please email [support@nexmo.com](mailto:support@nexmo.com) and include Messages API in the subject line. Please note that during the Developer Preview period support times are limited to Monday to Friday.

During Developer Preview Nexmo will expand the capabilities of the API.

## Nexmo Node library support

In addition to using the Messages API via HTTP, the Nexmo Node client library also provides support. During the Developer Preview the Node client librtary with support for the Messages API can be installed using:

```
$ npm install nexmo@beta
```

## Quickstart

The following code shows how to send an SMS message using the Messages API:

```
curl -X POST https://api.nexmo.com/beta/messages \
     -u 'API_KEY:API_SECRET' \
     -H 'Content-Type: application/json' \
     -H 'Accept: application/json' \
     -d $'{
	      "from": { "type": "sms", "number": "FROM_NUMBER" },
	      "to": { "type": "sms", "number": "TO_NUMBER" },
	      "message": {
	        "content": {
		      "type": "text",
		      "text": "This is an SMS sent from the Messages API"
	    }
   }
}'
```

In the above example you will need to:

1. Replace `API_KEY` and `API_SECRET` with your Nexmo API_KEY and API_SECRET respectively. These can be obtained from your Dashboard.
2. Replace `FROM_NUMBER` and `TO_NUMBER` with suitable phone numbers. The `FROM_NUMBER` would typically be a Nexmo Number but also could be any other number you own. The `TO_NUMBER` is the number of the phone to which the message will be sent. 

NOTE: Throughout the Nexmo APIs numbers are always specified in E.164 format, for example, 447700900000.

### Run the code

The example code will send an SMS to the number specified and return the message ID.