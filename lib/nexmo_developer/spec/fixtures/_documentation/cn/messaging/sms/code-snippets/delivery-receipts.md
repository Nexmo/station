---
title:  传递回执
description:  如何检索短信传递回执
navigation_weight:  4

---


传递回执
====

您可以通过向运营商索取[传递回执](/messaging/sms/guides/delivery-receipts)来验证使用 Nexmo 的短信 API 发送的消息是否已送达您的客户。

> **注意：** 并非所有的网络和国家都支持传递回执。如果您的网络不支持传递回执，您可以查看我们的知识库进一步了解您[可能收到](https://help.nexmo.com/hc/en-us/articles/204014863)的资料。有关传递回执的详细信息，请参阅我们的[文档](/messaging/sms/guides/delivery-receipts)。

要访问传递回执，您需要：

* 使用下面显示的代码示例之一[创建一个 Webhook 端点](/messaging/sms/code-snippets/before-you-begin#webhooks)
* [在 Nexmo Dashboard 中配置 Webhook 端点](#configure-the-webhook-endpoint-in-your-nexmo-dashboard)

> **注意：** 发送消息后，收到传递回执之前可能会有延迟。

```code_snippets
source: '_examples/messaging/sms/delivery-receipts'
```

在 Nexmo Dashboard 中配置 Webhook 端点
--------------------------------

为了使 Nexmo 知道如何访问您的 Webhook，您必须在 Nexmo 帐户中对其进行配置。

在代码片段中，Webhook 位于 `/webhooks/delivery-receipt`。如果您使用的是 Ngrok，则需要在 [Nexmo Dashboard API 设置页面](https://dashboard.nexmo.com/settings)配置的 Webhook 的格式为 `https://demo.ngrok.io/webhooks/delivery-receipt`。将`demo`替换为 Ngrok 提供的子域，然后在标有 **传递回执的 Webhook URL** 的字段中输入端点：

```screenshot
script: app/screenshots/webhook-url-for-delivery-receipt.js
image: public/assets/screenshots/smsDLRsettings.png
```

试试看
---

向手机号码[发送消息](send-an-sms)，如果网络支持，您将收到以下格式的传递回执：

```json
{
  "err-code": "0",
  "message-timestamp": "2020-10-25 12:10:29",
  "messageId": "0B00000127FDBC63",
  "msisdn": "447700900000",
  "network-code": "23410",
  "price": "0.03330000",
  "scts": "1810251310",
  "status": "delivered",
  "to": "Nexmo CLI"
}
```

> **注意：** 发送消息后，收到传递回执之前可能会有延迟。

更多信息
----

* [短信传递回执文档](/messaging/sms/guides/delivery-receipts)

