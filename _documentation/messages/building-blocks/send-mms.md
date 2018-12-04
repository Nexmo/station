---
title: Send an MMS
---

# Send an MMS

In this building block you will see how to send an MMS using the Messages API.

> **IMPORTANT:** Only US Short codes and US LVNs are currently supported. Recipients on T-Mobile are not supported.

## Example

Ensure the following variables are set to your required values using any convenient method:

Key | Description
-- | --
`US_FROM` | The US Short Code or US LVN you are sending the message from.
`TO_NUMBER` | The phone number you are sending the message to. T-Mobile network is not supported.
`IMG_URL` | The URL of the media you want to send

> **NOTE:** Don't use a leading `+` or `00` when entering a phone number, start with the country code, for example 447700900000.

```building_blocks
source: '_examples/messages/send-mms'
application:
  type: messages
  name: 'Send an MMS'
```

## Try it out

When you run the code an MMS message will be sent to the destination number.
