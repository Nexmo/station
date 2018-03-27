---
title: Send a message with failover
---

# Send a message with failover

In this example we will send a Facebook Messenger message that failsover to SMS. In the array you can order the messages in any order you want. Each message object must contain a failover object except for the last message as there is nothing to failover to.

Key | Description
-- | --
`NEXMO_APPLICATION_ID` |	The ID of the application that you created.
`FROM_NUMBER` | The phone number you are sending the message from in [E.164](https://en.wikipedia.org/wiki/E.164) format. For example `447700900000`.
`SENDER_ID` | Your sender ID. This value should be the `to.id` value you received in the inbound messenger event.
`RECIPIENT_ID` | The recipient ID is the Facebook user you are messaging. This value should be the `from.id` value you received in the inbound messenger event. It is sometimes called the PSID.

## Prerequisites

- *[Rent a virtual number](/account/guides/numbers#rent-virtual-numbers)*
- *[Create an application](/concepts/guides/applications#getting-started-with-applications)*

## Generate a JWT

```curl
$ JWT="$(nexmo jwt:generate /path/to/private.key \application_id=NEXMO_APPLICATION_ID)"
$ echo $JWT
```

## Example

```tabbed_examples
config: 'messages_and_workflows_apis.workflows.send-failover-sms-facebook'
```
