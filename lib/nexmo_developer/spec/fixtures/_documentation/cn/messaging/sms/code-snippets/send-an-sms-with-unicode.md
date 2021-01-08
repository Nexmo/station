---
title:  发送带有 Unicode 的短信
description:  如何使用 Nexmo 短信 API 发送 Unicode 短信
navigation_weight:  3

---


发送带有 Unicode 的短信
================

Nexmo 的短信 API 也支持 Unicode 字符，当您用中文、日文和韩文与客户交流时，需要使用 Unicode 字符。

要发送包含 Unicode 字符的短信，请在以下示例中替换下列变量：

密钥 | 说明
-- | --
`TO_NUMBER` | 您向其发送短信的号码，例如 `447700900000`。
`NEXMO_API_KEY` | 您可以在 Nexmo Dashboard 中找到此内容。
`NEXMO_API_SECRET` | 您可以在 Nexmo Dashboard 中找到此内容。

```code_snippets
source: '_examples/messaging/sms/send-an-sms-with-unicode'
```

试试看
---

当您运行上面的示例时，文本消息将发送到指定的手机号码，且 Unicode 字符完整无缺。

> 请注意，Unicode 消息只能包含 70 个字符，而不是通常的 160 个字符。[帮助页面上](https://help.nexmo.com/hc/en-us/articles/204076866-How-long-is-a-single-SMS-body-)有更多此内容的相关信息

延伸阅读
----

* [短信的级联和编码](/messaging/sms/guides/concatenation-and-encoding)
* [如何使用 Node.js 和 Express 发送短信](https://www.nexmo.com/blog/2016/10/19/how-to-send-sms-messages-with-node-js-and-express-dr/)
* [双向短信支持客户互动](/tutorials/two-way-sms-for-customer-engagement)

