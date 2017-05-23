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
