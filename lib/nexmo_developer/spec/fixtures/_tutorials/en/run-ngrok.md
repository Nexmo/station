---
title: How to run Ngrok
description: How to run Ngrok to test your application locally.
---

<a name="how-to-run-ngrok"></a>

You must make your webhook accessible to Vonage’s APIs over the public Internet. A straightforward way to achieve this during development without standing up your own server is to use [Ngrok](https://ngrok.com/). To learn more, [read our documentation on Ngrok](/tools/ngrok).

Download and install ngrok, then execute the following command to expose your application on port 3000 to the public Internet:

``` shell
./ngrok http 3000
```

If you are a paid subscriber you could type:

``` shell
./ngrok http 3000 -subdomain=your_domain
```

> **NOTE:** In this example Ngrok will divert the Vonage webhooks you specified when you created your Vonage application to `localhost:3000`. Although port 3000 is shown here, you can use any free port that is convenient.
