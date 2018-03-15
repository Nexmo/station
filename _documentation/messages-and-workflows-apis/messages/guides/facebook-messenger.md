---
title: Facebook Messenger
---

# Facebook Messenger

You can use the Messages API to send and receive messages using Facebook Messenger.

In Facebook Messenger, the default is for the customer to initiate a conversation first with a business. Facebook Messenger uses its own form of IDs for the Facebook Page (what the business communicates as) and the Facebook user. The Facebook user will have Page-scoped ID (PSID) and this is unique for each page. The business can only obtain the PSID of a user when the user first sends a message to the business.

In order to get started with Facebook Messenger you will need to first link your Facebook Page to Nexmo, at this point we will provide you with your Facebook Page ID. You will then need to send a message as a Facebook User to your Facebook Page. At this point you will receive an inbound message callback to your server with the PSID of the Facebook user. You can now use this PSID to send a message back to the user.

Follow these instructions to get setup:

## 1. Setup a Facebook Page

To use the Messages API with Facebook Messenger you must have a Facebook Account and a Facebook Page.

- [How do I create a Facebook Account?](https://en-gb.facebook.com/help/570785306433644/?helpref=hc_fnav)
- [How do I create a Facebook Page?](https://en-gb.facebook.com/help/104002523024878?helpref=about_content)

## 2. Link your Facebook Page to Nexmo

Next you'll need to link your Facebook page to Nexmo, this will allow us to handle the inbound messages and allow you to send messages from the Nexmo Messages API. You will need to generate a JWT to do this.

- [Subscribe your page to Facebook and Nexmo](https://static.nexmo.com/messenger/)

To generate a JWT with the app you have already created, you can do this using the Nexmo CLI tool.

Key | Description
-- | --
`NEXMO_APPLICATION_ID` |	The ID of the application that you created.

 ```curl
 $ JWT="$(nexmo jwt:generate /path/to/private.key \application_id=NEXMO_APPLICATION_ID)"
 $ echo $JWT
 ```

## 3. Configure your Delivery Receipt and Inbound Message endpoint with Nexmo

From [Nexmo Dashboard](https://dashboard.nexmo.com) go to [Settings](https://dashboard.nexmo.com/settings).

Set the HTTP Method to POST and enter your endpoint in the fields labeled **Webhook URL for Inbound Message** and **Webhook URL for Delivery Receipt**:

```screenshot
script: app/screenshots/webhook-url-for-inbound-message.js
image: public/assets/screenshots/dashboardSettings.png
```

## 4. Receiving a message (you need to recieve a message first)

When a message is sent to your page an event will be sent to your event endpoint, here is an example payload:

```json
{  
  "message_uuid":"aaaaaaaa-bbbb-cccc-dddd-0123456789ab",
  "to":{  
    "type":"messenger",
    "id":"0000000000000000"
  },
  "from":{  
    "type":"messenger",
    "id":"1111111111111111"
  },
  "timestamp":"2020-01-01T14:00:00.000Z",
  "message":{  
    "content":{  
      "type":"text",
      "text":"Hello from Facebook Messenger!"
    }
  }
}
```

## 5. Responding

You can use the Messages API to respond to the inbound message. Replace the following variables in the example below:

Key | Description
-- | --
`NEXMO_APPLICATION_ID` |	The ID of the application that you created.
`SENDER_ID` | Your sender ID. This value should be the `to.id` value you received in the inbound messenger event.
`RECIPIENT_ID` | The recipient ID is the Facebook user you are messaging. This value should be the `from.id` value you received in the inbound messenger event. It is sometimes called the PSID.

### Generate a JWT

 ```curl
 $ JWT="$(nexmo jwt:generate /path/to/private.key \application_id=NEXMO_APPLICATION_ID)"
 $ echo $JWT
 ```

### Example

```tabbed_examples
config: 'messages_and_workflows_apis.messages.send-facebook-messenger'
```
