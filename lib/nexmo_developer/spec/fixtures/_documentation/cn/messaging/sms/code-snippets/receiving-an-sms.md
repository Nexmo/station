---
title:  接收短信
navigation_weight:  5

---


接收短信
====

要接收短信，您需要：

* [租用虚拟号码](/numbers/guides/number-management#rent-a-virtual-number)以接收消息
* 使用下面显示的代码示例之一[创建一个 Webhook 端点](/messaging/sms/code-snippets/before-you-begin#webhooks)
* [在 Nexmo Dashboard 中配置 Webhook](#configure-the-webhook-endpoint-in-your-nexmo-dashboard)

```code_snippets
source: '_examples/messaging/sms/receiving-an-sms'
```

在 Nexmo Dashboard 中配置 Webhook 端点
--------------------------------

为了使 Nexmo 知道如何访问您的 Webhook，您必须在 Nexmo 帐户中对其进行配置。

在代码片段中，Webhook 位于 `/webhooks/inbound-sms`。如果您使用的是 Ngrok，则需要在 [Nexmo Dashboard API 设置页面](https://dashboard.nexmo.com/settings)配置的 Webhook 的格式为 `https://demo.ngrok.io/webhooks/inbound-sms`。将`demo`替换为 Ngrok 提供的子域，然后在标有 **入站消息的 Webhook URL** 的字段中输入端点：

```screenshot
script: app/screenshots/webhook-url-for-inbound-message.js
image: public/assets/screenshots/smsInboundWebhook.png
```

试试看
---

现在，当您向 Nexmo 号码发送短信时，您应该会在控制台中看到该短信。消息对象包含以下属性：

```json
{
  "msisdn": "447700900001",
  "to": "447700900000",
  "messageId": "0A0000000123ABCD1",
  "text": "Hello world",
  "type": "text",
  "keyword": "Hello",
  "message-timestamp": "2020-01-01T12:00:00.000+00:00",
  "timestamp": "1578787200",
  "nonce": "aaaaaaaa-bbbb-cccc-dddd-0123456789ab",
  "concat": "true",
  "concat-ref": "1",
  "concat-total": "3",
  "concat-part": "2",
  "data": "abc123",
  "udh": "abc123"
}
```

