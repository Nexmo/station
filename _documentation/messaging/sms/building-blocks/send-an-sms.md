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
tabs:
  curl:
    source: '_examples/messaging/sending-an-sms/basic/curl'
  node:
    source: '.repos/nexmo-community/nexmo-node-quickstart/sms/send.js'
    from_line: 9
  java:
    source: '.repos/nexmo-community/nexmo-java-quickstart/src/main/java/com/nexmo/quickstart/sms/SendMessage.java'
    from_line: 36
    to_line: 51
    unindent: true
  csharp:
    source: '.repos/nexmo-community/nexmo-dotnet-quickstart/NexmoDotNetQuickStarts/Controllers/SMSController.cs'
    from_line: 31
    to_line: 38
    unindent: true
  php:
    source: '.repos/nexmo-community/nexmo-php-quickstart/sms/send-sms.php'
    from_line: 9
  python:
    source: '.repos/nexmo-community/nexmo-python-quickstart/sms/__init__.py'
  ruby:
    source: '.repos/nexmo-community/nexmo-ruby-quickstart/sms/send.rb'
    from_line: 8
    to_line: 19
```
