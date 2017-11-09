---
title: Concatenation
---

# Concatenation

If you send a message that contains more than the maximum number of characters for your encoding, Nexmo sends a concatenated SMS. A concatenated SMS contains multiple SMS parts that are connected by segmentation information in the User Data Header (UDH). Segmentation information tells the handset the number of messages that make up the concatenated SMS, and the position of each SMS part in the concatenated SMS. The parts of a concatenated SMS arrive at the user's handset out of sequence. When the handset has received all the SMS parts, it presents your message as a single text to your user.

```partial
source: app/views/tools/concatenation.html
```

Segmentation information takes up 8 bytes of the message body for each SMS part. The maximum number of characters in the message body for each SMS part in a concatenated SMS is:

* 7-bit encoding such as Latin-1/9 and GSM8 - 152 characters.
* 8-bit encoding for binary - 134 characters.
* 16-bit encoding for Unicode - 66 characters.

You can send a message of up to 3200 characters in your request to the SMS API. Best practice is that the message in the text parameter is no longer than 6 SMS parts. For example, to send the first stanza of the balcony speech in Chinese, Nexmo would send a concatenated SMS with the following SMS parts:

```tabbed_examples
source: '_examples/messaging/chinese-parts'
```

You are charged for each SMS sent as part of a concatenated SMS.

If you rent one or more virtual numbers from Nexmo, inbound SMS to that number are sent to your webhook endpoint using either GET or POST. Inbound messages comply with the SMS format. If an SMS sent to your virtual number is longer than the [maximum number of characters](#maximum-number-of-characters) for an individual SMS, you should receive the concatenated message in SMS parts. Use the `concat-ref`, `concat-total` and `concat-part` parameters to reassemble the parts into the message. However, you can only receive inbound concatenated SMS if the carrier your user is sending through supports them. If the carrier who sent the inbound SMS does not support concatenation, a workaround is to consider messages coming from the same number within a close time period as concatenated.

Before you start your messaging campaign:

1. Check the format to send your message in. You can see the full UTF-8 character set [here](http://www.fileformat.info/info/charset/UTF-8/list.htm):

    Use <http://www.url-encode-decode.com/> to see if your message can be URL encoded. If you need to use another format, set the *type* parameter in your [request](/api/sms#request).

2. If you need to use Unicode, check if Unicode is supported in the country you are sending to [Country Specific Features](#country-specific-features).

3. Check in the [Country Specific Features](#country-specific-features) if concatenated messages are supported in the country you are sending to. If they are not:

    * Keep your message concise. Calculate the number of characters you can send in a message for your character set.
    * Configure your app for the time period workaround for inbound messages.
