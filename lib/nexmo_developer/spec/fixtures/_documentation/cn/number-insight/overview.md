---
title:  Overview
meta_title:  Number Insights API
description:  Vonage's Number Insight API delivers real\
---
time intelligence about the validity, reachability and roaming status of a phone number and tells you how to format the number correctly in your application. (Nexmo is now Vonage)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Number Insight API Overview
===========================

Vonage's Number Insight API delivers real-time intelligence about the validity, reachability and roaming status of a phone number and tells you how to format the number correctly in your application. (Nexmo is now Vonage).

目录
---

This document contains the following information:

* [Concepts](#concepts) - what you need to know
* [Basic, Standard and Advanced API levels](#basic-standard-and-advanced-apis) - understand their different capabilities
* **[Getting Started with the Number Insight API](#getting-started)** - try it out
* [Guides](#guides) - learn how to use the Number Insight API
* [代码片段](#code-snippets) - 帮助完成特定任务的代码片段
* [用例](#use-cases) - 带有代码示例的详细用例
* [参考](#reference) - 完整的 API 文档

概念
---

* [Webhooks](/concepts/guides/webhooks) - you can use the Advanced API to return comprehensive data about a number to your application when it becomes available, via a webhook.

Basic, Standard and Advanced APIs
---------------------------------

Each API level builds upon the capabilities of the previous one. For example, the Standard API includes all of the locale and formatting information from the Basic API and returns extra data about the type of number, whether it is ported and the identity of the caller (US only). The Advanced API provides the most comprehensive data. It includes everything that is available in the Basic and Standard APIs and adds roaming and reachability information.

> Unlike the Basic and Standard APIs which are synchronous APIs, the Advanced API is intended to be used asynchronously.

### Typical use cases

* **Basic API** : Discovering which country a number belongs to and using the information to format the number correctly.
* **Standard API** : Determining whether the number is a landline or mobile number (to choose between voice and SMS contact) and blocking virtual numbers.
* **Advanced API** : Ascertaining the risk associated with a number.

### Feature comparison

| Feature                                    | Basic | Standard | Advanced |
|:-------------------------------------------|:-----:|:--------:|:--------:|
| Number format and origin                   |   ✅   |    ✅     |    ✅     |
| Network type                               |   ❌   |    ✅     |    ✅     |
| Carrier and country                        |   ❌   |    ✅     |    ✅     |
| Ported                                     |   ❌   |    ❌     |    ✅     |
| Validity                                   |   ❌   |    ❌     |    ✅     |
| Reachability (not available in the US) |   ❌   |    ❌     |    ✅     |
| Roaming status                             |   ❌   |    ❌     |    ✅     |
| Roaming carrier and country                |   ❌   |    ❌     |    ✅     |
| **US number** caller name and type         |   ❌   |    ✅     |    ✅     |

> Check the legislation in your country to ensure that you are allowed to save user roaming information.

入门
---

This example shows you how to use the [Nexmo CLI](/tools) to access the Number Insight Basic API and display information about a number.

> For examples of how to use Basic, Standard and Advanced Number Insight with `curl` and the developer SDKs see the [Code Snippets](#code-snippets).

### Before you begin:

* Sign up for a [Vonage API account](https://dashboard.nexmo.com/signup)
* Install [Node.JS](https://nodejs.org/en/download/)

### Install and set up the Nexmo CLI
````
$ npm install -g nexmo-cli
````
> Note: Depending on your user permissions, you might need to prefix the above command with `sudo`.

Use your `VONAGE_API_KEY` and `VONAGE_API_SECRET` from the [dashboard getting started page](https://dashboard.nexmo.com/getting-started-guide) to set up the Nexmo CLI with your credentials:
````
$ nexmo setup VONAGE_API_KEY VONAGE_API_SECRET
````
### Execute a Number Insight API Basic lookup

Execute the example command shown below, replacing the phone number with one that you want information about:
````
nexmo insight:basic 447700900000
````
### View the response

The Basic API response lists the number together with the country the number is located in. For example:
````
447700900000 | GB
````
Use the `--verbose` flag (or `-v`) to see everything that the Basic API response contains:
````
$ nexmo insight:basic --verbose 447700900000

[status]
0

[status_message]
Success

[request_id]
aaaaaaaa-bbbb-cccc-dddd-0123456789ab

[international_format_number]
447700900000

[national_format_number]
07700 900000

[country_code]
GB

[country_code_iso3]
GBR

[country_name]
United Kingdom

[country_prefix]
44
````
指南
---

```concept_list
product: number-insight
```

代码片段
----

```code_snippet_list
product: number-insight
```

用例
---

```use_cases
product: number-insight
```

参考
---

* [Number Insight API Reference](/api/number-insight)

