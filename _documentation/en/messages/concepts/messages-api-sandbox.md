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

1. Navigate to the [Messages API Sandbox](#https://dashboard.nexmo.com/messages/sandbox) on the dashboard.
2. Click the **Add to sandbox** option associated with the messaging platform for which you want to create a sandbox.
3. Configure and save webhooks. The **Inbound** webhook is the URL to which inbound messages are forwarded. The **Status** webhook is the URL at which you will receive message status updates.
4. Invite team members to use a sandbox by selecting their names in the **Select a user** drop-down list. You can invite new team members by clicking **Invite a new user to your team** and adding them on the **Team members** page.

## Whitelist your mobile to receive messages

In order to use the Messages API Sandbox to test sending messages on messaging platforms such as Facebook Messenger, Viber, and WhatsApp, you must first whitelist your mobile by sending a message with a passphrase to a sandbox account. There are two methods for adding your mobile to a sandbox whitelist:

1. [Whitelist your mobile via the dashboard](#whitelist-your-mobile-via-the-dashboard).
2. [Whitelist your mobile via an email invitation](#whitelist-your-mobile-via-an-email-invitation).

### Whitelist your mobile via the dashboard

1. Navigate to the [Messages API Sandbox](#https://dashboard.nexmo.com/messages/sandbox) on the dashboard.
2. Either scan the QR code associated with the messaging platform sandbox you wish to use and send the message the passphrase or send a message with the passphrase to the associated number or linked account that is provided.
3. 

### Whitelist your mobile via an email invitation

1. Following the instructions in the email invitation specific to your mobile OS, scan the QR code displayed.
2. Send a message with the passphrase provided in the email invitation.

## Send a message on a supported messaging service via the Messages API Sandbox
Once you are added to the whitelist, you will use a Messages API Sandbox endpoint to send your test messages using the appropriate `from` id or number associated with the specific platform's sandbox. For your sandbox testing purposes, the `from` field is already populated in the code snippets provided below. It is important to note that you will need to replace the value in the `from` field with the number or ID associated with the business account you setup on the external messaging platform.

1. Create a new `sandbox-message.sh` file.
2. Copy the code snippet for the appropriate messaging platform and paste it in the `sandbox-message.sh` file.
3. Replace the value in the `to` field with the number or ID associated with your external messaging account that is whitelisted in the sandbox.
4. Save the file to your machine and run it.

