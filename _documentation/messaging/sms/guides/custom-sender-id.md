---
title: Custom Sender ID
---

# Custom Sender ID

**How to set the number or name your message is sent from**

The Sender ID is the number or text shown on a handset when it displays a message. You set a custom Sender ID to better represent your brand. The Sender ID can be either:
* Numeric - up to a 15 digit telephone number in international format without a leading `+` or `00`
* Alphanumeric - an 11 digit string made up of the following supported characters: `abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789`

Using other characters may result in failed delivery or an altered Sender ID.

However, depending on the jurisdiction one or more of the following can happen:

* Your Sender ID must be a virtual number.
* SMS filtering is applied and the Sender ID is modified.
* Numeric-only Sender IDs are replaced by short codes.
* You can only send traffic in a limited time window.
* For marketing traffic you have to implement a STOP system.

> Note: [SMS spoofing](https://en.wikipedia.org/wiki/SMS_spoofing) is strictly forbidden.

Before you start your messaging campaign:

1. Check the Sender ID columns in the [Country Specific Features](#country-specific-features).
2. Batch send your messages to each country and set `from` to match the Sender ID capabilities.
