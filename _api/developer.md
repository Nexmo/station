---
title: API reference
description: Reference guide for the Account API.
api: Developer API
---

# API reference

@TODO: Add intro copy

## Account

@TODO: Add account copy

### Authentication information

If you are not using applications, you use the following parameters for calls to Nexmo API:

Parameter | Description
-- | --
`api_key` | You can find this in your [account overview](https://dashboard.nexmo.com/account-overview)
`api_secret` | You can find this in your [account overview](https://dashboard.nexmo.com/account-overview)

### Get Balance

Retrieve the current balance of your Nexmo account

#### Request

```
[GET] https://rest.nexmo.com/account/get-balance
```

#### Response

The following shows example Responses in JSON or XML:

**JSON**

```json
{
  "value": 3.14159,
  "autoReload": false
}
```

*or* **XML**

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<accountBalance>
  <value>17.79185</value>
  <autoReload>false</autoReload>
</accountBalance>
```

##### Keys and Values

The response contains the following keys and values:

Key | Value
-- | --
`value` | The accounts remaining balance in euros.
`autoReload` | A boolean indicating if autoReload is enabled on your account.

### Pricing

Retrieve our outbound pricing for a given country

#### Request

```
[GET] https://rest.nexmo.com/account/get-pricing/outbound
```

##### Parameters

The following shows the parameters you use in the request:

Parameter | Description | Required
-- | -- | --
`country` | 	A 2 letter [country code](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2). For example, `CA` | Yes

#### Response

The following shows example Responses in JSON or XML:

**JSON**

```json
{
  "country": "GB",
  "name": "United Kingdom",
  "prefix": "44",
  "mt": "0.03330000",
  "networks": [
    {
      "code": "12345",
      "network": "Acme Telco",
      "mtPrice": "0.03330000"
    },
  ],
  "countryDisplayName": "United Kingdom"
}
```

*or* **XML**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<outbound-country-pricing>
  <countryDisplayName>United Kingdom</countryDisplayName>
  <country>GB</country>
  <name>United Kingdom</name>
  <prefix>44</prefix>
  <mt>0.03330000</mt>
  <networks>
    <network>
      <code>12345</code>
      <name>Acme Telco</name>
      <mtPrice>0.03330000</mtPrice>
    </network>
  </networks>
</outbound-country-pricing>
```

##### Keys and Values

The response contains the following keys and values:

Key | Value
-- | --
`value` | The accounts remaining balance in euros.

### Settings

Retrieve our outbound pricing for a given country

#### Request

```
[POST] https://rest.nexmo.com/account/settings
```

##### Parameters

The following shows the parameters you use in the request:

Parameter | Description | Required
-- | -- | --
`newSecret` | Your new API secret. Your API Secret must be an 8 - 25 character long Alphanumeric with at least one number, lower & upper case character. |  No
`moCallBackUrl` | An URL encoded URI to the webhook endpoint endpoint that handles inbound messages. Your webhook endpoint must be active before you make this request, Nexmo makes a [GET] request to your endpoint and checks that it returns a `200 OK` response. Set to empty string to clear. | No
`drCallBackUrl` | An URL encoded URI to the webhook endpoint endpoint that handles delivery receipts (DLR). Your webhook endpoint must be active before you make this request, Nexmo makes a [GET] request to your endpoint and checks that it returns a `200 OK` response. Set to empty string to clear. | No

#### Response

The following shows example Responses in JSON or XML:

**JSON**

```json
{
  "api-secret": "API_SECRET",
  "mo-callback-url": "https://example.com/mo",
  "dr-callback-url": "https://example.com/dr",
  "max-outbound-request": 30,
  "max-inbound-request": 30
}
```

*or* **XML**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<account-settings>
   <api-secret>API_SECRET</api-secret>
   <mo-callback-url>https://example.com/mo</mo-callback-url>
   <dr-callback-url>https://example.com/dr</dr-callback-url>
   <max-outbound-request>30</max-outbound-request>
   <max-inbound-request>30</max-inbound-request>
</account-settings>
```

##### Keys and Values

The response contains the following keys and values:

Key | Value
-- | --
`api-secret` | The current or updated API Secret
`mo-callback-url` | The current or updated inbound message URI
`dr-callback-url` | The current or updated delivery receipt URI
`max-outbound-request` | The maximum amount of outbound messages per second.
`max-inbound-request` | The maximum amount of inbound messages per second.

## Numbers

### List owned numbers

Retrieve all the inbound numbers associated with your Nexmo account.

#### Request

```
[GET] https://rest.nexmo.com/account/numbers
```

##### Parameters

The following shows the parameters you use in the request:

Parameter | Description | Required
-- | -- | --
`index` | Page index [Default: 1] | No
`size` | Page size [Max: 100] [Default: 10] | No
`pattern` | A matching pattern | No
`search_pattern` | Strategy for matching pattern. Expected values: `0` (starts with, default), `1` (anywhere), `2` (ends with). | No

#### Response

The following shows example Responses in JSON or XML:

**JSON**

```json
{
  "count": 1,
  "numbers": [
    {
      "country": "GB",
      "msisdn": "447700900000",
      "moHttpUrl": "https://example.com/mo",
      "type": "mobile-lvn",
      "features": [
        "VOICE",
        "SMS"
      ],
      "voiceCallbackType": "app",
      "voiceCallbackValue": "aaaaaaaa-bbbb-cccc-dddd-0123456789ab"
    },
  ]
}
```

*or* **XML**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<inbound-numbers>
   <count>1</count>
   <numbers>
      <country>GB</country>
      <msisdn>447700900000</msisdn>
      <mo-http-url>https://example.com/mo</mo-http-url>
      <type>mobile-lvn</type>
      <features>
         <feature>VOICE</feature>
         <feature>SMS</feature>
      </features>
      <voice-callback-type>app</voice-callback-type>
      <voice-callback-value>aaaaaaaa-bbbb-cccc-dddd-0123456789ab</voice-callback-value>
   </numbers>
</inbound-numbers>
```

##### Keys and Values

The response contains the following keys and values:

Key | Value
-- | --
`count` | The total amount of numbers owned by account.
`numbers` | An paginated array of numbers and their details.

### Search available numbers

Retrieve inbound numbers that are available for a given country.

#### Request

```
[GET] https://rest.nexmo.com/numbers/search
```

##### Parameters

The following shows the parameters you use in the request:

Parameter | Description | Required
-- | -- | --
`country` | The two character country code in ISO 3166-1 alpha-2 format. | Yes
`pattern` | A number pattern to search for. | No
`search_pattern` | Strategy for matching pattern. Expected values: `0` (starts with, default), `1` (anywhere), `2` (ends with). | No
`features` | Available features are SMS and VOICE. For both features, use a comma-separated value SMS,VOICE. | No
`size` | Page size [Max: 100] [Default: 10] | No
`index` | Page index [Default: 1] | No

#### Response

The following shows example Responses in JSON or XML:

**JSON**

```json
{
  "count": 1234,
  "numbers": [
    {
      "country": "GB",
      "msisdn": "447700900000",
      "cost": "0.50",
      "type": "mobile",
      "features": [
        "VOICE",
        "SMS",
      ]
    },
    ...
  ]
}
```

*or* **XML**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<inbound-numbers>
  <count>1234</count>
  <numbers>
     <country>GB</country>
     <msisdn>447700900000</msisdn>
     <cost>0.50</cost>
     <type>mobile</type>
     <features>
        <feature>VOICE</feature>
        <feature>SMS</feature>
     </features>
  </numbers>
  ...
</inbound-numbers>
```

##### Keys and Values

The response contains the following keys and values:

Key | Value
-- | --
`count` | The total amount of numbers available in the pool.
`numbers` | An paginated array of available numbers and their details.

### Buy a number

Request to purchase a specific inbound number.

#### Request

```
[POST] https://rest.nexmo.com/number/buy
```

##### Parameters

The following shows the parameters you use in the request:

Parameter | Description | Required
-- | -- | --
`country` | The two character country code in ISO 3166-1 alpha-2 format. | Yes
`msisdn` | An available inbound virtual number. For example, `447700900000`. | Yes

#### Response

The following shows example Responses in JSON or XML:

**JSON**

```json
{
  "error-code":"200",
  "error-code-label":"success"
}
```

*or* **XML**

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<response>
  <error-code>200</error-code>
  <error-code-label>success</error-code-label>
</response>
```

##### Keys and Values

The response contains the following keys and values:

Key | Value
-- | --
`count` | The total amount of numbers owned by account.
`numbers` | An paginated array of numbers and their details.

### Cancel a number

Cancel your subscription for a specific inbound number.

#### Request

```
[POST] https://rest.nexmo.com/number/cancel
```

##### Parameters

The following shows the parameters you use in the request:

Parameter | Description | Required
-- | -- | --
`country` | The two character country code in ISO 3166-1 alpha-2 format. | Yes
`msisdn` | One of your inbound numbers. For example, `447700900000`. | Yes

#### Response

The following shows example Responses in JSON or XML:

**JSON**

```json
{
  "error-code":"200",
  "error-code-label":"success"
}
```

*or* **XML**

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<response>
  <error-code>200</error-code>
  <error-code-label>success</error-code-label>
</response>
```

##### Keys and Values

The response contains the following keys and values:

Key | Value
-- | --
`count` | The total amount of numbers owned by account.
`numbers` | An paginated array of numbers and their details.

### Update a number

Change the behaviour of a number that you own

#### Request

```
[POST] https://rest.nexmo.com/number/update
```

##### Parameters

The following shows the parameters you use in the request:

Parameter | Description | Required
-- | -- | --
`country` | The two character country code in ISO 3166-1 alpha-2 format. | Yes
`msisdn` | An available inbound virtual number. For example, `447700900000`. | Yes
`moHttpUrl` | An URL encoded URI to the webhook endpoint endpoint that handles inbound messages. Your webhook endpoint must be active before you make this request, Nexmo makes a [GET] request to your endpoint and checks that it returns a `200 OK` response. Set to empty string to clear. | No
`moSmppSysType` | The associated system type for your SMPP client. For example `inbound`. | No
`voiceCallbackType` | The voice webhook type. Possible values are `sip`, `tel`, `vxml` (VoiceXML) or `app` | No
`voiceCallbackValue` | A URI for your `voiceCallbackType` or an Application ID
`voiceStatusCallback` | Nexmo sends a request to this webhook endpoint when a call ends. | No

#### Response

The following shows example Responses in JSON or XML:

**JSON**

```json
{
  "error-code":"200",
  "error-code-label":"success"
}
```

*or* **XML**

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<response>
  <error-code>200</error-code>
  <error-code-label>success</error-code-label>
</response>
```

### Cancel a number

Cancel your subscription for a specific inbound number.

#### Request

```
[POST] https://rest.nexmo.com/number/cancel
```

##### Parameters

The following shows the parameters you use in the request:

Parameter | Description | Required
-- | -- | --
`country` | The two character country code in ISO 3166-1 alpha-2 format. | Yes
`msisdn` | One of your inbound numbers. For example, `447700900000`. | Yes

#### Response

The following shows example Responses in JSON or XML:

**JSON**

```json
{
  "error-code":"200",
  "error-code-label":"success"
}
```

*or* **XML**

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<response>
  <error-code>200</error-code>
  <error-code-label>success</error-code-label>
</response>
```

## Message

### Search

Retrieve information about a single messages that you sent using SMS API or were received on your number.

#### Request

```
[POST] https://rest.nexmo.com/search/message
```

##### Parameters

The following shows the parameters you use in the request:

Parameter | Description | Required
-- | -- | --
`id` | The ID of the message you want to retrieve. | Yes

#### Response

The following shows example Responses in JSON or XML:

**Outbound Message**

**JSON**

```json
{
  "message-id": "0A00000000ABCD00",
  "account-id": "API_KEY",
  "network": "012345",
  "from": "Nexmo",
  "to": "447700900000",
  "body": "A text message sent using the Nexmo SMS API",
  "price": "0.03330000",
  "date-received": "2020-01-01 12:00:00",
  "final-status": "DELIVRD",
  "date-closed": "2020-01-01 12:00:00",
  "latency": 3000,
  "type": "MT"
}
```

*or* **XML**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<message>
  <message-id>0A00000000ABCD00</message-id>
  <account-id>API_KEY</account-id>
  <network>012345</network>
  <from>Nexmo</from>
  <to>447700900000</to>
  <body>A text message sent using the Nexmo SMS API</body>
  <price>0.03330000</price>
  <date-received>2020-01-01 12:00:00</date-received>
  <final-status>DELIVRD</final-status>
  <date-closed>2020-01-01 12:00:00</date-closed>
  <latency>3000</latency>
  <type>MT</type>
</message>
```

**Inbound Message (MO)**

```json
{
  "message-id": "0B00000053FFB40F",
  "account-id": "API_KEY",
  "network": "012345",
  "from": "447700900000",
  "to": "447700900001",
  "body": "A text message sent to Nexmo from another number",
  "date-received": "2020-01-01 12:00:00",
  "type": "MO"
}
```

*or* **XML**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<message>
  <message-id>0B00000053FFB40F</message-id>
  <account-id>API_KEY</account-id>
  <network>012345</network>
  <from>447700900000</from>
  <to>447700900001</to>
  <body>A text message sent to Nexmo from another number</body>
  <date-received>2020-01-01 12:00:00</date-received>
  <type>MO</type>
</message>
```

##### Keys and Values

The response contains the following keys and values:

Key | Value
-- | --
`type` | The message type. `MT` (mobile terminated or outbound) or `MO` (mobile originated or inbound)
`message-id` | The id of the message you sent.
`account-id` | Your API Key.
`network` | The [MCCMNC](https://en.wikipedia.org/wiki/Mobile_Network_Code) for the carrier who delivered the message.
`from` | The sender ID the message was sent from. Could be a phone number or name.
`to` | The phone number the message was sent to.
`body` | The body of the message
`date-received` | The date and time at UTC+0 when Platform received your request in the following format: `YYYY-MM-DD HH:MM:SS`.

**Fields for MT messages only**

Key | Value
-- | --
`price` | Price in Euros for a MT message
`date-closed` | The date and time at UTC+0 when Platform received the delivery receipt from the carrier who delivered the MT message. This parameter is in the following format YYYY-MM-DD HH:MM:SS
`latency` | The overall latency between `date-received` and `date-closed` in milliseconds.
`client-ref` | The [internal reference](/api/sms#keys-and-values) you set in the request.
`final-status` | The status of `message-id` at `date-closed`. @[Possible values](/_modals/api/developer/message/search/response/final-status.md).
`error-code-label` | A text label to explain `error-code`
`status` | A code that explains where the message is in the delivery process. If status is not `delivered` check `error-code` for more information. If status is `accepted` ignore the value of `error-code`. @[Possible values](/_modals/api/developer/message/search/response/status.md).
`error-code` | If the `status` is not `accepted` this key will have one of these @[possible values](/_modals/api/developer/message/search/response/error-code.md).

### Retrieve multiple messages

Retrieve multiple messages that you sent using SMS API or were received on your number.

#### Request

```
[POST] https://rest.nexmo.com/search/messages
```

##### Parameters

The following shows the parameters you use in the request:

**Search by message ID**

Parameter | Description | Required
-- | -- | --
`ids` | The list of up to 10 message IDs to search for. For example: `ids=00A0B0C0&ids=00A0B0C1&ids=00A0B0C2` | Yes

*or* **Search by recipient and date**

Parameter | Description | Required
-- | -- | --
`date` | The date the request to SMS API was submitted in the following format: `YYYY-MM-DD` | Yes
`to` | The phone number the message was sent to. | Yes

#### Response

The following shows example Responses in JSON or XML:

**JSON**

```json
{
  "count": 2,
  "items": [
    {
      "message-id": "0A00000000ABCD00",
      "account-id": "API_KEY",
      "network": "012345",
      "from": "Nexmo",
      "to": "447700900000",
      "body": "A text message sent using the Nexmo SMS API",
      "price": "0.03330000",
      "date-received": "2020-01-01 12:00:00",
      "final-status": "DELIVRD",
      "date-closed": "2020-01-01 12:00:00",
      "latency": 3000,
      "type": "MT"
    },
    {
      "message-id": "0B00000053FFB40F",
      "account-id": "API_KEY",
      "network": "012345",
      "from": "447700900000",
      "to": "447700900001",
      "body": "This is an inbound message test",
      "date-received": "2020-01-01 12:00:00",
      "type": "MO"
    }
  ]
}
```

*or* **XML**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<messages>
  <count>2</count>
  <items>
    <message>
      <message-id>0A00000000ABCD00</message-id>
      <account-id>API_KEY</account-id>
      <network>12345</network>
      <from>447700900000</from>
      <to>447700900001</to>
      <body>This is an inbound message test</body>
      <date-received>2017-05-22020-01-01 12:00:00 09:50:43</date-received>
      <type>MO</type>
    </message>
    <message>
      <message-id>0A00000000ABCD01</message-id>
      <account-id>API_KEY</account-id>
      <network>12345</network>
      <from>Nexmo</from>
      <to>447700900000</to>
      <body>A text message sent using the Nexmo SMS API</body>
      <price>0.03330000</price>
      <date-received>2020-01-01 12:00:00</date-received>
      <final-status>DELIVRD</final-status>
      <date-closed>2020-01-01 12:00:00</date-closed>
      <latency>3000</latency>
      <type>MT</type>
    </message>
  </items>
</messages>
```

##### Keys and Values

The response contains the following keys and values:

Key | Value
-- | --
`type` | The message type. `MT` (mobile terminated or outbound) or `MO` (mobile originated or inbound)
`message-id` | The id of the message you sent.
`account-id` | Your API Key.
`network` | The [MCCMNC](https://en.wikipedia.org/wiki/Mobile_Network_Code) for the carrier who delivered the message.
`from` | The sender ID the message was sent from. Could be a phone number or name.
`to` | The phone number the message was sent to
`body` | The body of the message
`date-received` | The date and time at UTC+0 when Platform received your request in the following format: `YYYY-MM-DD HH:MM:SS`.

**Fields for MT messages only**

Key | Value
-- | --
`price` | Price in Euros for a MT message
`date-closed` | The date and time at UTC+0 when Platform received the delivery receipt from the carrier who delivered the MT message. This parameter is in the following format YYYY-MM-DD HH:MM:SS
`latency` | The overall latency between `date-received` and `date-closed` in milliseconds.
`client-ref` | The [internal reference](/api/sms#keys-and-values) you set in the request.
`final-status` | The status of `message-id` at `date-closed`. @[Possible values](/_modals/api/developer/message/search/response/final-status.md).
`error-code-label` | A text label to explain `error-code`
`status` | A code that explains where the message is in the delivery process. If status is not `delivered` check `error-code` for more information. If status is `accepted` ignore the value of `error-code`. @[Possible values](/_modals/api/developer/message/search/response/status.md).
`error-code` | If the `status` is not `accepted` this key will have one of these @[possible values](/_modals/api/developer/message/search/response/error-code.md).
