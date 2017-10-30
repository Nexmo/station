---
title: SMS API Reference
api: SMS
---

# SMS API Reference

## Send an SMS

* [Request](#request) - send an SMS to a user.
* [Response](#response) - ensure that your request to the SMS API was successful.
* [Delivery Receipt](#delivery-receipt) - check that the user received your message.
* [Inbound messages](#inbound-messages) - handle inbound messages from the user.

### Request

An SMS API *request* looks like:

```sh
curl -X "POST" "https://rest.nexmo.com/sms/json" \
  -d "from=Nexmo" \
  -d "text=A text message sent using the Nexmo SMS API" \
  -d "to=TO_NUMBER" \
  -d "api_key=API_KEY" \
  -d "api_secret=API_SECRET"
```

This request contains:

* [Base URL](#base)
* [Parameters](#parameters)
* [Authentication information](#authentic)
* [Security](#security)
* [Encoding](#encode)

#### Base URL

All requests to the SMS API must contain `https://rest.nexmo.com/sms` followed by either `/json` or `/xml` depending on the response content type. Your base URL becomes either:

**JSON**

```
https://rest.nexmo.com/sms/json
```

*or* **XML**

```
https://rest.nexmo.com/sms/xml
```

#### Parameters
The following table shows the parameters you use in the request:

Parameter | Description | Required
-- | -- | --
`from` | An alphanumeric string giving your sender address. For example, `from=MyCompany20`. See our information [Global messaging](/messaging/sms/guides/global-messaging). This is also called the SenderID. | Yes.
`to` | A single phone number in **international format**, that is [E.164](https://en.wikipedia.org/wiki/E.164). For example, `to=447700900000`. You can set one recipient only for each request. | Yes.
`type` | Default value is `text`. Possible values are: <ul><li>text - for plain text SMS, you must also set the *`text`* parameter.</li><li>binary - for binary SMS you must also set the **udh** and *`body`* parameters. Do not set the *`text`* parameter.</li><li>wappush - a [WAP Push](https://en.wikipedia.org/wiki/Wireless_Application_Protocol#WAP_Push). You must also set the `title` and `url` parameters. Do not set the `text` or `body` parameters.</a></li><li>unicode - SMS in [unicode](https://en.wikipedia.org/wiki/unicode) contain fewer characters than `text`. Only use *unicode* when your SMS must contain special characters. For more information, see [Encoding](/messaging/sms/guides/global-messaging#encoding). </li><li>vcal - send a calendar event. You send your [vCal](https://en.wikipedia.org/wiki/VCal) encoded calendar event in the *vcal* parameter.</li><li>vcard - send a business card. You send your [vCard](https://en.wikipedia.org/wiki/VCard) encoded business card in the the *vcard* parameter. </li></ul>| No.
`text` |  The SMS body. Messages where *type* is text (the default) are in UTF-8 with URL encoding. You send "Déjà vu" as a text (type=text) message as long as you encode it as D%C3%A9j%C3%A0+vu. You can see the full UTF-8 character set [here](http://www.fileformat.info/info/charset/UTF-8/list.htm). To test if your message can be URL encoded, use: <http://www.url-encode-decode.com/>. If you cannot find the character you want to send in these two references, you should use unicode. For more information, see [Encoding](/messaging/sms/guides/global-messaging#encoding).   | For `text` type SMS.
`status-report-req` | Set to `1` to receive a [Delivery Receipt](#delivery_receipt) (DLR). To receive the DLR, you have to either: <ul><li>Configure a [webhook endpoint](/concepts/guides/webhooks) in Dashboard.</li><li>Set the *callback* parameter.</li></ul> | No.
`vcard` | A business card in [vCard](https://en.wikipedia.org/wiki/VCard). You must set the *type* parameter to *vcard*. | No.
`vcal` | A calendar event in [vCal](https://en.wikipedia.org/wiki/VCal). You must set the *type* parameter to *vcal*.
`ttl` | The lifespan of this SMS in milliseconds. | No
`callback` | The webhook endpoint the delivery receipt for this sms is sent to. This parameter overrides the webhook endpoint you set in Dashboard. This must be a fully formed URL. For example: https://mysite.com/sms_api_callback.php. | No
`message-class` | Set to: 0 for Flash SMS, 1 - ME-specific, 2 - SIM / USIM specific, 3 - TE-specific See <http://en.wikipedia.org/wiki/Data_Coding_Scheme> Note: Flash SMS is not fully support by all handsets and carriers. | No
`udh` |  Your custom Hex encoded [User Data Header (UDH)](https://en.wikipedia.org/wiki/User_Data_Header). For example, `udh=06050415811581`. | For *binary* type SMS.
`protocol-id` | The value in decimal format for the [higher level protocol](https://en.wikipedia.org/wiki/GSM_03.40#Protocol_Identifier) to use for this SMS. For example, to send a binary SMS to the SIM Toolkit, this would be *protocol-id=127*. Ensure that the value of *protocol-id* is aligned with *udh*. |  For *binary* type SMS.
`body` |Hex encoded binary data. For example, `body=0011223344556677`. |  For *binary* type SMS.
`title` | The title for a `wappush` SMS. For example: MyCompanyIsGreat. | For `wappush` type SMS.
`url` | The URL your user taps to navigate to your website. | For `wappush` type SMS.
`validity` | The availability period for a `wappush` type SMS in milliseconds. For example, validity=86400000. If you do not set this parameter, the default is 48 hours. | No.
`client-ref` | If enabled, you can include a 40 character maximum length string for internal reporting/analytics. You will need to email support@nexmo.com to get this functionality enabled on your account. | No

#### Authentication information

If you are not using applications, you use the following parameters for calls to Nexmo API:

Parameter | Description
-- | --
`api_key` | Your Key. For example: `api_key=NEXMO_API_KEY`
`api_secret` | Your Secret. For example: `api_secret=NEXMO_API_SECRET`

> Note: You find your Key and Secret in Dashboard.

If you are using signatures to verify your requests use:

Parameter | Description
-- | --
`api_key` | Your Key. For example: `api_key=NEXMO_API_KEY`
`sig` | The hash of the request parameters in alphabetical order, a timestamp and the signature secret. For example: `sig=SIGNATURE`

#### Security

To ensure privacy, you must use HTTPS for all Nexmo API requests.

#### Encoding

You submit all requests with a [POST] or [GET] call using `UTF-8` encoding and URL encoded values. The expected Content-Type for [POST] is `application/x-www-form-urlencoded`. For calls to a JSON endpoint, we also support:

* `application/json`
* `application/jsonrequest`
* `application/x-javascript`
* `text/json`
* `text/javascript`
* `text/x-javascript`
* `text/x-json` when posting parameters as a JSON object.

If you are using `GET`, you must set [`Content-Length`](https://en.wikipedia.org/wiki/List_of_HTTP_header_fields#Request_fields) in the request header.

### Response

Each request you make using the SMS API returns a:

[Response](#keys) - the status and price of your request to Nexmo in JSON or XML format.
[Delivery receipt](#delivery_receipt) - the status and cost of the SMS sent by Nexmo to your user.

> *Note*: you are only charged for correctly submitted outbound SMS. If status is not 0, you are not charged.

The response is send in the api.txt file when you make a request from the browser.

Each response comes:

* In a specific [Format](#format)
* With [Keys and values](#keys)

### Format

You set the response type using the [Base URL](#base). The following table shows example responses in JSON or XML:

```tabbed_examples
source: '/_examples/api/sms/sending/response-format'
```

### Keys and Values

The response contains the following keys and values:

```tabbed_content
source: '/_examples/api/sms/sending/keys-and-values/'
```

#### Error codes

Code | Text | Meaning
-- | -- | --
`0` | Success | The message was successfully accepted for delivery by Nexmo.
`1` | Throttled | You have exceeded the submission capacity allowed on this account. Please wait and retry.
`2` | Missing params | Your request is incomplete and missing some mandatory parameters.
`3` | Invalid params | The value of one or more parameters is invalid.
`4` | Invalid credentials | The `api_key` / `api_secret` you supplied is either invalid or disabled.
`5` | Internal error | There was an error processing your request in the Platform.
`6` | Invalid message | The Platform was unable to process your request. For example, due to an unrecognised prefix for the phone number.
`7` | Number barred | The number you are trying to submit to is blacklisted and may not receive messages.
`8` | Partner account barred | The api_key you supplied is for an account that has been barred from submitting messages.
`9` | Partner quota exceeded | Your pre-paid account does not have sufficient credit to process this message.
`11` | Account not enabled for REST | This account is not provisioned for REST submission, you should use SMPP instead.
`12` | Message too long | The length of `udh` and `body` was greater than 140 octets for a `binary` type SMS request.
`13` | Communication Failed | Message was not submitted because there was a communication failure.
`14` | Invalid Signature | Message was not submitted due to a verification failure in the submitted signature.
`15` | Illegal Sender Address - rejected | Due to local regulations, the SenderID you set in from in the request was not accepted. Please check the Global messaging section.
`16` | Invalid TTL | The value of `ttl` in your request was invalid.
`19` | Facility not allowed | Your request makes use of a facility that is not enabled on your account.
`20` | Invalid Message class | The value of message-class in your request was out of range. `See` https://en.wikipedia.org/wiki/Data_Coding_Scheme.
`23` | Bad callback :: Missing Protocol | You did not include `https` in the URL you set in callback.
`29` | Non White-listed Destination | The phone number you set in to is not in your pre-approved destination list. To send messages to this phone number, add it `using` Dashboard.
`34` | Invalid or Missing Msisdn Param | The phone number you supplied in the to parameter of your request was either missing or invalid.

**The following response codes are for 2FA and Campaign Subscription Management only.**

Code | Text
-- | -- | --
`101` | `RESPONSE_INVALID_ACCOUNT_CAMPAIGN`

**The following response codes are for 2FA only.**

Code | Text | Meaning
-- | -- | --
`102` | `RESPONSE_MSISDN_OPTED_OUT_FOR_CAMPAIGN` | You tried to send a message to a destination number that has opted out of your program.

**The following response codes are for Campaign Subscription Management only.**

Code | Text
-- | --
`102` | `RESPONSE_INVALID_CAMPAIGN_SHORTCODE`
`103` | `RESPONSE_INVALID_MSISDN`

#### Examples

This section gives examples of:

**Successful responses**

```tabbed_examples
source: '_examples/api/sms/sending/successful-response'
```

**Successful response, sent in three parts**

```tabbed_examples
source: '_examples/api/sms/sending/successful-response-multi-part'
```

**Error responses**

```tabbed_examples
source: '_examples/api/sms/sending/error-response'
```

## Delivery Receipt

Each request you make using the Nexmo API returns a:

* Response - the status and cost of your request to Nexmo in JSON or XML format.
* Delivery Receipt - if you have set a webhook endpoint, Nexmo forwards this delivery receipt to it. Carriers return a Delivery Receipt (DLR) to Nexmo to explain the delivery status of your message. If the message is not received, the delivery receipt explains why your message failed to arrive.

The Delivery Receipt is sent using a [GET] HTTP request to your webhook endpoint. When you receive the DLR, you must send a 200 OK response. If you do not send the `200 OK`, Nexmo resends the delivery receipt for the next 72 hours.

When you implement your response, ensure that your logic is not case-sensitive for the response codes.

A Delivery Receipt has a:

* Format
* Keys and Values

### Format

The following code shows an example of a Delivery Receipt:

```tabbed_content
source: '_examples/api/us-short-codes/alerts/delivery-receipt-format'
```

### Keys and Values

The Nexmo Delivery Receipt includes:

Key | Value
-- | --
`to` | The SenderID you set in from in your request.
`network-code` | The Mobile Country Code Mobile Network Code (MCCMNC) of the carrier this phone number is registered with.
`messageId` | The Nexmo ID for this message.
`msisdn` | The phone number this message was sent to.
`status` | A code that explains where the message is in the delivery process., If status is not delivered check err-code for more information. If status is accepted ignore the value of err-code. @[Possible values](_examples/api/us-short-codes/alerts/delivery-receipt/status.md)
`err-code` | If the status is not accepted, this key will have one of the these @[possible values](_examples/api/us-short-codes/alerts/delivery-receipt/err-code.md)
`price` | How much it cost to send this message.
`scts` | The Coordinated Universal Time (UTC) when the DLR was recieved from the carrier. The scts is in the following format: YYMMDDHHMM. For example, 1101181426 is 2011 Jan 18th 14:26.
`message-timestamp` | The time at UTC±00:00 when Nexmo started to push this Delivery Receipt to your webhook endpoint. The message-timestamp is in the following format YYYY-MM-DD HH:MM:SS. For example, 2020-01-01 12:00:00.
`client-ref` | The client-ref you set in the request.

### Inbound messages

If you rent one or more virtual numbers from Nexmo, inbound messages to that number are sent to your [webhook endpoint](/concepts/guides/webhooks). inbound messages comply to the SMS format, if a message sent to your virtual number is longer than maximum number of characters, *concat* is *true* and you receive the message in parts. Use the `concat-ref`, `concat-total` and `concat-part` parameters to reassemble the parts into the message.

Inbound messages are sent using a [GET] or [POST] HTTP request to your [webhook endpoint](/concepts/guides/webhooks). When you receive an inbound message, you must send a `200 OK` response. If you do not send the `200 OK`, Nexmo resends the inbound message for the next 24 hours.


#### Keys and Values

The inbound message includes:

Key | Value | Required
--|--|--
`type` | Possible values are: <ul><li>text - standard text.</li><li>unicode - [URLencoded ](https://en.wikipedia.org/wiki/Percent-encoding#The_application.2Fx-www-form-urlencoded_type) [unicode](https://en.wikipedia.org/wiki/unicode). This is valid for standard GSM, Arabic, Chinese, double-encoded characters and so on.</li><li>binary - a binary message.</li></ul>| Yes
`to` | The phone number the message was sent to. **This is your virtual number**.| Yes
`msisdn` | The phone number that this inbound message was sent from. | Yes
`messageId` | The Nexmo ID for this message.| Yes
`message-timestamp` | The time at [UTC±00:00](https://en.wikipedia.org/wiki/UTC%C2%B100:00) that Nexmo started to push this inbound message to your [webhook endpoint](/concepts/guides/webhooks). The *message-timestamp* is in the following format *YYYY-MM-DD HH:MM:SS*. For example, *2020-01-01 12:00:00*.| Yes
`timestamp` | A unix timestamp representation of *message-timestamp*. | If your messages are [signed](/concepts/guides/signing-messages)
`nonce` | A random string that forms part of the signed set of parameters, it adds an extra element of unpredictability into the signature for the request. You use the *nonce* and *timestamp* parameters with your shared secret to calculate and validate the signature for inbound messages. | If your messages are [signed](/concepts/guides/signing-messages)


**For an inbound message**

Key | Value | Required
-- | -- | --
`text` | The message body for this inbound message.| If *type* is `text` |
`keyword` | The first word in the message body. This is typically used with short codes. | If *type* is `text` |


**For *concatenated* inbound messages**

Key | Value | Required
-- | -- | --
`concat` | *True* - if this is a concatenated message. | Yes
`concat-ref` | The transaction reference. All parts of this message share this `concat-ref`.| If *concat* is *True*
`concat-total` | The number of parts in this concatenated message.| If *concat* is *True*
`concat-part` | The number of this part in the message. Counting starts at *1*. | If *concat* is *True*


**For binary messages**

Key | Value | Required
-- | -- | --
`data` | The content of this message| If *type* is *binary*
`udh` | The hex encoded [User Data Header](https://en.wikipedia.org/wiki/User_Data_Header) | If *type* is *binary*
