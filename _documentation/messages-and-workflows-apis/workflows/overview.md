---
title: Overview
---

# Overview

The Workflows API enables the developer to send messages to users using a multiple channel strategy. 

An example workflow might specify a message to be sent a message via Facebook Messenger, and if that message is not read then the user can be sent a message via Viber. If that message is also not read a user could then be sent a message via SMS.

The Workflows API provides the mechanism by which to order messages and specify their _success conditions_. The Workflows API uses the Messages API to actually send the messages.

In this release you can:

* **Send** SMS, Facebook Messenger and Viber Service Messages with Workflows built on-top of the the [Messages API](/messages-and-workflows-apis/messages/overview).
* **Failover** to the next message if the condition status is not met within the time period or if the message immediately fails.

The condition status is the status that the message returns. With Facebook Messenger and Viber Service Messages, you can use `delivered` and `read` statuses as the condition status. With SMS you can only use `delivered`.

The following diagram illustrates the relationship between the Workflows API and the Messages API:

![Workflows and Messages](/assets/images/messages-workflows-overview.png)

## Developer Preview

This API is currently in Developer Preview and you will need to [request access](https://www.nexmo.com/products/messages) to use it.

In this release Nexmo provides a failover template. The failover template instructs the [Messages API](messages-and-workflows-apis/messages/overview) to send a message to the specified channel. If that message fails immediately or if the `condition_status` is not reached within the specified time period the next message is sent.

Nexmo always welcomes your feedback. Your suggestions help us improve the product. If you do need help, please email [support@nexmo.com](mailto:support@nexmo.com) and include Workflow API in the subject line. Please note that during the Developer Preview period support times are limited to Monday to Friday.

## Quickstart

The following code shows how to create a workflow that attempts to send a message via Facebook messenger and if not read within the time limit a message will be sent via SMS:

```
curl -X POST https://api.nexmo.com/beta/workflows \
  -u 'API_KEY:API_SECRET' \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -d $'{
    "template":"failover",
    "workflow": [
      {
        "from": { "type": "messenger", "id": "SENDER_ID" },
        "to": { "type": "messenger", "id": "RECIPIENT_ID" },
        "message": {
          "content": {
            "type": "text",
            "text": "This is a Facebook Messenger Message sent from the Workflows API"
          }
        },
        "failover":{
          "expiry_time": 600,
          "condition_status": "read"
        }
      },
      {
        "from": {"type": "sms", "number": "FROM_NUMBER"},
        "to": { "type": "sms", "number": "TO_NUMBER"},
        "message": {
          "content": {
            "type": "text",
            "text": "This is an SMS sent from the Workflows API"
          }
        }
      }
    ]
  }'
```

In the above example code you will need to:

1. Replace `API_KEY` and `API_SECRET` with your Nexmo API_KEY and API_SECRET respectively. These can be obtained from your Dashboard.
2. Replace `SENDER_ID` with the ID of the Facebook page. Replace `RECIPIENT_ID` with the ID of the Facebook user you are sending the message to. 
3. Replace `FROM_NUMBER` and `TO_NUMBER` with suitable phone numbers. The `FROM_NUMBER` would typically be a Nexmo Number but also could be any other number you own. The `TO_NUMBER` is the number of the phone to which the message will be sent. 

NOTE: Throughout the Nexmo APIs numbers are always specified in E.164 format, for example, 447700900000.

### Run the code

The example code will send a message via Facebook Messenger and if not read within the expiry time an SMS will be sent.