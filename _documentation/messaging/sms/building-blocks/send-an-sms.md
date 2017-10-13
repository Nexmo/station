---
title: Send an SMS
description: How to send an SMS with the Nexmo SMS API
navigation_weight: 1
---

# Sending an SMS

Sending an SMS message with Nexmo is easy. Simply [sign up for an account](https://dashboard.nexmo.com/sign-up) and replace the following variables in the example below:

| Key | Description |
| -------- | ----------- |
| `TO_NUMBER` | The number you are sending the SMS to in [E.164](https://en.wikipedia.org/wiki/E.164) format. For example `442079460000`. |
| `API_KEY` | You can find this in your [account overview](https://dashboard.nexmo.com/account-overview) |
| `API_SECRET` | You can find this in your [account overview](https://dashboard.nexmo.com/account-overview) |

<h2>Local code:</h2>

```tabbed_examples
source: '_examples/messaging/sending-an-sms/basic'
```

<h2>Quickstart repo code:</h2>

```tabbed_examples
config: messaging.sms.send
```
