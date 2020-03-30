---
title: Messages API Sandbox
navigation_weight: 5
description: Understanding and utilizing the Messages API Sandbox.
---

# Using the Messages API Sandbox

The Messages API Sandbox provides a quick and easy method for sending test messages using the Vonage Messages API on supported messaging platforms without requiring the setup of business accounts on any of those platforms. This means you can code your application now while you wait for your business accounts are created and approved. The Messages API Sandbox can be used to send test messages on the following messaging platforms:

* Facebook Messenger
* Viber
* WhatsApp

The Messages API Sandbox is accessible via the dashboard. You can use it to test your integration prior to sending production traffic, at which point, you will change the `from` id.

## The steps

The steps to use the Messages API Sandbox to send test messages on supported messaging platforms are as follows:

1. [Create your sandbox accounts](#create-your-sandbox-accounts).
2. [Whitelist your mobile to receive messages](#whitelist-your-mobile-to-receive-messages).

## Create your sandbox accounts

Only primary users can create sandboxes and send email invitations to them.

1. Navigate to the Messages API Sandbox on the dashboard.
2. Click the tbd button.
3. Configure webhooks.
4. Invite team members to use a sandbox by selecting their names in the **Select a user** drop-down list.

## Whitelist your mobile to receive messages

In order to use the Messages API Sandbox to test sending messages on OTT messaging platforms such as Facebook Messenger, Viber, and WhatsApp, you must first whitelist your mobile to receive messages by sending a message with a passphrase to a sandbox account. There are two methods for adding your mobile to a sandbox whitelist:

1. [Whitelist your mobile via the dashboard](#whitelist-your-mobile-via-the-dashboard).
2. [Whitelist your mobile via an email invitation](#whitelist-your-mobile-via-an-email-invitation).

### Whitelist your mobile via the dashboard

1. Navigate to the Messages API Sandbox on the dashboard.
2. Either scan the QR code associated with the messaging platform sandbox you wish to use and send the message containing the pre-populated passphrase or send a message with the passphrase to the associated number or linked account that is provided.
3. TBD.

### Whitelist your mobile via an email invitation

1. Following the instructions in the email invitation specific to your mobile OS, scan the QR code displayed.
2. Send a message with the passphrase provided in the email invitation.

## Send a message on a supported messaging service via the Messages API Sandbox
Once you are added to the whitelist, you will use a Messages API Sandbox endpoint to send your test messages using the appropriate `from` id or number associated with the specific platform's sandbox.

