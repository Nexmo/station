---
title:  发送短信
description:  如何使用 Nexmo 短信 API 发送短信
navigation_weight:  2

---


发送短信
====

要发送短信，请在以下示例中替换下列变量：

密钥 | 说明
-- | --
`TO_NUMBER` | 您要以 E.164 格式向其发送短信的号码。示例：`447700900000`。
`NEXMO_API_KEY` | 您可以在帐户概述中找到此内容
`NEXMO_API_SECRET` | 您可以在帐户概述中找到此内容

```code_snippets
source: '_examples/messaging/sms/send-an-sms'
```

试试看
---

当您运行上面的示例时，短信将发送到您指定的手机号码。

延伸阅读
----

* [如何使用 Node.js 和 Express 发送短信](https://www.nexmo.com/blog/2016/10/19/how-to-send-sms-messages-with-node-js-and-express-dr/)
* [双向短信支持客户互动](/tutorials/two-way-sms-for-customer-engagement)

