---
title: Developer - Account API Reference
description: Reference guide for the Account API.
api: Developer API
---

# Developer - Account API Reference

## Account

The Account API allows you to retrieve your balance, change settings on your account, and lookup pricing information for particular countries.

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

```tabbed_examples
source: _examples/api/developer/account/get-balance
```

##### Keys and Values

The response contains the following keys and values:

Key | Value
-- | --
`value` | The accounts remaining balance in euros.
`autoReload` | A boolean indicating if autoReload is enabled on your account.

### Pricing by country

Retrieve our outbound pricing for a given country

#### Request

```
[GET] https://rest.nexmo.com/account/get-pricing/outbound/:type
```

##### Parameters

The following shows the parameters you use in the request:

Parameter | Description | Required
-- | -- | --
`type` | The type of service you wish to retrieve data about: either `sms`, `sms-transit` or `voice`. | No
`api_key` | Your Nexmo API key. | Yes
`api_secret` | Your Nexmo API secret. | Yes
`country` | 	A 2 letter [country code](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2). For example, `CA` | Yes

#### Response

The following shows example Responses in JSON or XML:

```tabbed_examples
source: _examples/api/developer/account/pricing/per-country-pricing/
```

##### Keys and Values

The response contains the following keys and values:

Key | Value
-- | --
`dialingPrefix` | The numerical dialing prefix code for the country in question (e.g. for the United Kingdom, `44`, for the United States `1`)
`currency` | The currency that your account is being billed in (by default: Euros—`EUR`). Changeable via the Dashboard to US Dollars—`USD`.
`countryDisplayName` | The display name for the country you looked up: e.g. `United Kingdom`, `Belgium`, `Japan`.
`countryCode` | The code for the country you looked up: e.g. `GB`, `US`, `BR`, `RU`.
`countryName` | The name for the country you looked up: e.g. `United Kingdom`.
`networks` | An array containing networks.
`networks` → `type` | The type of network: `mobile` or `landline`.
`networks` → `price` | The cost to send a message or make a call to this network
`networks` → `currency` | The currency used for prices for this network.
`networks` → `ranges` | A list of number prefixes that belong to this network.
`networks` → `mcc` | The [Mobile Country Code](https://en.wikipedia.org/wiki/Mobile_country_code) of the operator.
`networks` → `mnc` | The Mobile Network Code of the operator.
`networks` → `networkCode` | The Mobile Country Code and Mobile Network Code combined to give a unique reference for the operator.
`networks` → `networkName` | The company/organisational name of the operator.

The number prefix ranges refer to who owns the number range. In many countries it is possible to port your number from mobile operator to another: number prefix ranges refer to who owns the number range, but a mobile subscriber using a ported number may be using a network different from the owner of the network. You can use the [Number Insight API](/number-insight) to look up individual numbers to see if they have been ported.

### Pricing for all countries

Retrieve our outbound pricing for all countries.

#### Request

```
[GET] https://rest.nexmo.com/account/get-full-pricing/outbound/:type
```

##### Parameters

The following shows the parameters you use in the request:

Parameter | Description | Required
-- | -- | --
`type` | The type of service you wish to retrieve data about: either `sms`, `sms-transit` or `voice`. | Yes
`api_key` | Your Nexmo API key. | Yes
`api_secret` | Your Nexmo API secret. | Yes

#### Response

The following shows example Responses in JSON or XML:

```tabbed_examples
tabs:
  JSON:
    source: _examples/api/developer/account/pricing/full-pricing/JSON
    from_line: 1
    to_line: 20
  XML:
    source: _examples/api/developer/account/pricing/full-pricing/XML
    from_line: 1
    to_line: 20
```

The responses are quite lengthy. Full responses are viewable on GitHub. <!-- TODO: add link -->


##### Keys and Values

The response contains the following keys and values:

Key | Value
-- | --
`count` | The number of countries returned in the response.
`countries` | An array containing each country.

For each country, the following information is provided:

Key | Value
-- | --
`dialingPrefix` | The numerical dialing prefix code for the country in question (e.g. for the United Kingdom, `44`, for the United States `1`)
`currency` | The currency that your account is being billed in (by default: Euros—`EUR`). Changeable via the Dashboard to US Dollars—`USD`.
`countryDisplayName` | The display name for the country you looked up: e.g. `United Kingdom`, `Belgium`, `Japan`.
`countryCode` | The code for the country you looked up: e.g. `GB`, `US`, `BR`, `RU`.
`countryName` | The name for the country you looked up: e.g. `United Kingdom`.
`networks` | An array containing networks.
`networks` → `type` | The type of network: `mobile` or `landline`.
`networks` → `price` | The cost to send a message or make a call to this network
`networks` → `currency` | The currency used for prices for this network.
`networks` → `ranges` | A list of number prefixes that belong to this network.
`networks` → `mcc` | The [Mobile Country Code](https://en.wikipedia.org/wiki/Mobile_country_code) of the operator.
`networks` → `mnc` | The Mobile Network Code of the operator.
`networks` → `networkCode` | The Mobile Country Code and Mobile Network Code combined to give a unique reference for the operator.
`networks` → `networkName` | The company/organisational name of the operator.

The number prefix ranges refer to who owns the number range. In many countries it is possible to port your number from mobile operator to another: number prefix ranges refer to who owns the number range, but a mobile subscriber using a ported number may be using a network different from the owner of the network. You can use the [Number Insight API](/number-insight) to look up individual numbers to see if they have been ported.

### Settings

Modify settings for your account including callback URLs and your API secret.

#### Request

```
[POST] https://rest.nexmo.com/account/settings
```

##### Parameters

The following shows the parameters you use in the request:

Parameter | Description | Required
-- | -- | --
`moCallBackUrl` | An URL encoded URI to the webhook endpoint endpoint that handles inbound messages. Your webhook endpoint must be active before you make this request, Nexmo makes a [GET] request to your endpoint and checks that it returns a `200 OK` response. Set to empty string to clear. | No
`drCallBackUrl` | An URL encoded URI to the webhook endpoint endpoint that handles delivery receipts (DLR). Your webhook endpoint must be active before you make this request, Nexmo makes a [GET] request to your endpoint and checks that it returns a `200 OK` response. Set to empty string to clear. | No

#### Response

The following shows example Responses in JSON or XML:

**JSON**

```tabbed_examples
source: _examples/api/developer/account/settings
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

### Top up

You can top-up your account using Developer API when you have enabled Auto-Reload in Dashboard. The amount added to your account at each top up is based on your initial reload-enable payment. That is, if you topped up `€50.00` when you enabled auto-reload, `€50.00` is automatically credited to your account when your balance reaches `€20.00`.

Your account balance is checked every 10 minutes. If you are sending a lot of messages, use this API to manage reloads when remaining-balance in the response goes below a specific amount.

#### Request

```
[POST] https://rest.nexmo.com/account/top-up
```

##### Parameters

The following shows the parameters you use in the request:

Parameter | Description | Required
-- | -- | --
`trx` | The ID associated with your original auto-reload transaction. For example, `00X123456Y7890123Z`. | Yes

#### Response

HTTP code | Description
-- | --
`200 OK` | Top up successful
`401 Unauthorized` | You have not setup auto-reload in Dashboard
`420 Enhance Your Calm` | Top up failed
