---
title:  开始之前
navigation_weight:  1

---


开始之前
====

什么是代码片段？
--------

代码片段是可以在自己的应用程序中重复使用的短代码段。
代码片段使用[示例存储库](https://github.com/topics/nexmo-quickstart)中的代码。

在尝试使用代码片段之前，请仔细阅读此信息。

先决条件
----

1. [创建 Nexmo 帐户](/account/guides/dashboard-management#create-and-configure-a-nexmo-account) - 这样您就可以访问您的 API 密钥和密码来验证请求。
2. [租用 Nexmo 号码](/numbers/guides/number-management#rent-a-virtual-number) - 如果您想要接收入站短信。
3. 为您选择的编程语言[安装 REST 客户端库](/tools)。

Webhook
-------

如果要接收传入的短信或传递回执，则需要创建 [Webhook](/concepts/guides/webhooks) 。Nexmo 需能够通过公共互联网访问您的 Webhook。

在开发过程中，您可以使用 [Ngrok](https://ngrok.com) 将在本地计算机上创建的 Webhook 公开给 Nexmo 的 API。有关如何设置和使用 Ngrok 的详细信息，请参阅[将 Ngrok 用于本地开发](/concepts/guides/testing-with-ngrok) 。

