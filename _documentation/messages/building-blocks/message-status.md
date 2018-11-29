---
title: Receive message status callback
navigation_weight: 6
---

# Message status

In this building block you will see how to receive message status updates.

## Example

Ensure that your message status [webhook is set](/messages/building-blocks/configure-webhooks) in the Dashboard. As a minimum your handler must return a 200 status code to avoid unnecessary callback queuing. Make sure your webhook server is running before testing your Messages application.

```building_blocks
source: '_examples/messages/message-status'
application:
  type: messages
  name: 'Message status'
```

## Try it out

The webhook will be invoked on changing message status and details printed to the console.
