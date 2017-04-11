---
title: Buy a number
navigation_weight: 1
wip: true
---

# Buy a number

To make and receive calls with the [Voice API](/voice/), and to receive messages using the [SMS API](/sms/), you need to buy a number to use with the API.

Numbers rented through Nexmo may support SMS, voice, or both. You need to purchase one that supports the API you intend to use. You can get landline, mobile or toll-free numbers through Nexmo. Which classes of numbers are available and what features they offer differ by country.

If you intend to use the SMS API, be sure to check the list of [country-specific features](/messaging/sms/guides/global-messaging#country-specific-features) as not all messaging features are available in all countries.

## Web 

You can purchase numbers using the Dashboard in the [Your Numbers](https://dashboard.nexmo.com/your-numbers) section.

## Nexmo CLI

### Search for a number

The Node.js-based [Nexmo CLI](https://github.com/nexmo/nexmo-cli) allows you to search for and buy numbers using the `nexmo number:search` (or `nexmo ns`) command.

#### Parameters:

<!-- This section is borrowed from the README for nexmo-cli. -->

- `country_code` - an ISO 3166-2 country code for the country you are trying to find a number for.
- Optional flags:

  - `--pattern <pattern>` to be matched in number (use * to match end or start of number)
  - `--voice` to search for voice enabled numbers
  - `--sms` search for SMS enabled numbers
  - `--size` the amount of results to return
  - `--page` the page of results to return

#### Example

<!-- This section is borrowed from the README for nexmo-cli. -->

```
> nexmo number:search US
12057200555
12069396555
12069396555
12155961555

> nexmo number:search NL --sms --pattern *007 --verbose
msisdn      | country | cost | type       | features
-----------------------------------------------------
31655551007 | NL      | 3.00 | mobile-lvn | VOICE,SMS
31655552007 | NL      | 3.00 | mobile-lvn | VOICE,SMS
31655553007 | NL      | 3.00 | mobile-lvn | VOICE,SMS
```

### Buy a number

Once you have located a number to purchase, you can use the Nexmo CLI command `nexmo number:buy` (or `nexmo nb`) to purchase the number.

#### Parameters

<!-- This section is borrowed from the README for nexmo-cli. -->

- `number` - The number to buy
- or `country_code` and `pattern` - The country and search pattern to find a number for and directly buy.

#### Examples

<!-- This section is borrowed from the README for nexmo-cli. -->

```
> nexmo number:buy 12069396555
Buying 12069396555\. This operation will charge your account.

Please type "confirm" to continue: confirm

Number purchased

> nexmo number:buy US *555
Buying 12069396555\. This operation will charge your account.

Please type "confirm" to continue: confirm

Number purchased: 12069396555

> nexmo number:buy 12069396555 --confirm
Number purchased: 12069396555
```

## API

The Developer API allows you to search for and buy numbers.

### Search for a number

```tabbed_content
source: _examples/concepts/buy-a-number-search/
```

#### Parameters

