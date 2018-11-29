---
title: Receive an inbound message
navigation_weight: 5
---

# Inbound message

In this building block you will see how to handle an inbound message.

## Example

Ensure that your inbound message [webhook is set](/messages/building-blocks/configure-webhooks) in the Dashboard.  As a minimum your handler must return a 200 status code to avoid unnecessary callback queuing. Make sure your webhook server is running before testing your Messages application.

```building_blocks
source: '_examples/messages/inbound-message'
application:
  type: messages
  name: 'Inbound message'
```

## Try it out

The webhook will be invoked on inbound message and the message details and data printed to the console.
