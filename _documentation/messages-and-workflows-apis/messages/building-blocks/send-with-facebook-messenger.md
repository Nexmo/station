---
title: Send with Facebook Messenger
---

# Send with Facebook Messenger

Sending an Facebook Messenger message with the Messages API is straightforward. Sign up for an account and replace the following variables in the example below:

Key | Description
-- | --
`NEXMO_APPLICATION_ID` |	The ID of the application that you created.
`SENDER_ID` | Your sender ID. This value should be the `to.id` value you received in the inbound messenger event.
`RECIPIENT_ID` | The recipient ID is the Facebook user you are messaging. This value should be the `from.id` value you received in the inbound messenger event. It is sometimes called the PSID.

## Prerequisites

- *[Create an application](/concepts/guides/applications#getting-started-with-applications)*

## Generate a JWT

```curl
$ JWT="$(nexmo jwt:generate /path/to/private.key \application_id=NEXMO_APPLICATION_ID)"
$ echo $JWT
```

## Example

```tabbed_examples
config: 'messages_and_workflows_apis.messages.send-facebook-messenger'
```
