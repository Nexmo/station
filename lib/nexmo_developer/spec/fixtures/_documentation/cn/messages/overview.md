---
title:  Overview
meta_title:  Send messages via SMS, MMS, WhatsApp, Viber and Facebook Messenger with a single API.
navigation_weight:  1

---


Messages API Overview
=====================

The Messages API allows you to send and in some cases receive messages over the following communications channels:

* SMS/MMS
* Facebook Messenger
* Viber
* WhatsApp

Further channels may be supported in the future.

The following diagram illustrates the relationship between the Messages API and the Dispatch API:

![Messages and Dispatch Overview](/assets/images/messages-dispatch-overview.png)

目录
---

* [Beta](#beta)
* [Supported features](#supported-features)
* [外部帐户 API](#external-accounts-api)
* [入门](#getting-started)
* [概念](#concepts)
* [代码片段](#code-snippets)
* [教程](#tutorials)
* [用例](#use-cases)
* [参考](#reference)

Beta
----

This API is currently in Beta.

Nexmo always welcomes your feedback. Your suggestions help us improve the product. If you do need help, please email [api.support@vonage.com](mailto:api.support@vonage.com) and include the Messages API in the subject line. Please note that during the Beta period, support times are limited to Monday to Friday.

During Beta Nexmo will expand the capabilities of the API.

Supported features
------------------

In this release the following features are supported:

| Channel            | Outbound Text | Outbound Image | Outbound Audio | Outbound Video | Outbound File | Outbound Template |
|:-------------------|:-------------:|:--------------:|:--------------:|:--------------:|:-------------:|:-----------------:|
| 短信                 |       ✅       |      n/a       |      n/a       |      n/a       |      n/a      |        n/a        |
| 彩信                 |       ✅       |       ✅        |      n/a       |      n/a       |      n/a      |        n/a        |
| Viber 服务消息         |       ✅       |       ✅        |      n/a       |      n/a       |      n/a      |         ✅         |
| Facebook Messenger |       ✅       |       ✅        |       ✅        |       ✅        |       ✅       |         ✅         |
| WhatsApp           |       ✅       |       ✅        |       ✅        |       ✅        |       ✅       |         ✅         |

| Channel            | Inbound Text | Inbound Image | Inbound Audio | Inbound Video | Inbound File | Inbound Location |
|:-------------------|:------------:|:-------------:|:-------------:|:-------------:|:------------:|:----------------:|
| 彩信                 |      ✅       |       ✅       |      n/a      |      n/a      |     n/a      |       n/a        |
| Viber 服务消息         |      ✅       |      n/a      |      n/a      |      n/a      |     n/a      |       n/a        |
| Facebook Messenger |      ✅       |       ✅       |       ✅       |       ✅       |      ✅       |        ✅         |
| WhatsApp           |      ✅       |       ✅       |       ✅       |       ✅       |      ✅       |        ✅         |

Limited support is also provided for [custom objects](/messages/concepts/custom-objects):

| Channel            | Outbound Button | Outbound Location | Outbound Contact |
|:-------------------|:---------------:|:-----------------:|:----------------:|
| 短信                 |       n/a       |        n/a        |       n/a        |
| 彩信                 |       n/a       |        n/a        |       n/a        |
| Viber 服务消息         |        ✅        |        n/a        |       n/a        |
| Facebook Messenger |        ✅        |        n/a        |       n/a        |
| WhatsApp           |        ✅        |         ✅         |        ✅         |

**Key:** 

* ✅ = Supported.
* ❌ = Supported by the channel, but not by Nexmo.
* n/a = Not supported by the channel.

外部帐户 API
--------

The [External Accounts API](/api/external-accounts) is used to manage your accounts for Viber Service Messages, Facebook Messenger and WhatsApp when using those channels with the Messages and Dispatch APIs.

入门
---

In this example you will need to replace the following variables with actual values using any convenient method:

Key | Description
-- | --
`NEXMO_API_KEY` | Nexmo API key which can be obtained from your [Nexmo Dashboard](https://dashboard.nexmo.com).
`NEXMO_API_SECRET` | Nexmo API secret which can be obtained from your [Nexmo Dashboard](https://dashboard.nexmo.com).
`FROM_NUMBER` | A phone number you own or some text to identify the sender.
`TO_NUMBER` | The number of the phone to which the message will be sent.

> **NOTE:** Don't use a leading `+` or `00` when entering a phone number, start with the country code, for example 447700900000\.

The following code shows how to send an SMS message using the Messages API:

```code_snippets
source: '_examples/messages/sms/send-sms-basic-auth'
```

概念
---

```concept_list
product: messages
```

代码片段
----

```code_snippet_list
product: messages
```

教程
---

* [How to send an SMS message](/messages/tutorials/send-sms-with-messages/introduction)
* [How to send a Viber message](/messages/tutorials/send-viber-message/introduction)
* [How to send a WhatsApp message](/messages/tutorials/send-whatsapp-message/introduction)
* [How to send a Facebook Messenger message](/messages/tutorials/send-fbm-message/introduction)

用例
---

```use_cases
product: messages
```

参考
---

* [Messages API Reference](/api/messages-olympus)
* [External Accounts API Reference](/api/external-accounts)

