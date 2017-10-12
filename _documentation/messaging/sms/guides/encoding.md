---
title: Encoding
---

# Encoding

By default all text SMS sent by Nexmo are in UTF-8 with URL encoding. A message saying `Hello World`, `Bonjour monde` or `Hola mundo` is delivered seamlessly.

However, sending `Привет мир`, `שלום עולם` or `مرحبا بالعالم` requires more thought. Languages such as Arabic, Chinese, Korean, Japanese, or Cyrillic alphabet languages need the 16-bit characters available in unicode. You can also send messages in binary, wappush, vcal and vcard formats.

## Maximum number of characters

The maximum number of characters you can fit into a single message depends on the encoding you are using:

* 7-bit encoding such as latin-1/9 and GSM8 - 160 characters.

    ```
    But, soft! what light through yonder window breaks?
    It is the east, and Juliet is the sun.
    Arise, fair sun, and kill the envious moon,
    Who is already sick and
    ```
  > Note: the [GSM alphabet](https://en.wikipedia.org/wiki/GSM_03.38) contains an extended alphabet. Characters in the extended alphabet are escaped and use up 2 characters *escape character + character* For example, `£` or `€` are sent as `\£` or `\€`.

* 8-bit encoding for binary - 140 characters.

    ```
    But, soft! what light through yonder window breaks?
    It is the east, and Juliet is the sun.
    Arise, fair sun, and kill the envious moon,
    Who
    ```

* 16-bit encoding for unicode - 70 characters.

    ```
    But, soft! what light through yonder window breaks?
    It is the east, and
    ```

If you use [SMPP](/messaging/sms/guides/SMPP-access) rather than REST, the default character encoding is Latin 1 ([ISO-8859-1](https://en.wikipedia.org/wiki/ISO/IEC_8859-1)). Binary and unicode are supported following the [SMPP 3.4](http://opensmpp.org/specs/smppv34_gsmumts_ig_v10.pdf) specification. You change the encoding of messages sent using SMPP in the `API settings` in [Dashboard](https://dashboard.nexmo.com). Changes take effect after an SMPP rebind.

Before you start your messaging campaign:

1. Check the format to send your message in. You can see the full UTF-8 character set [here](http://www.fileformat.info/info/charset/UTF-8/list.htm):

    Use <http://www.url-encode-decode.com/> to see if your message can be URL encoded. If you need to use another format, set the *type* parameter in your [request](/api/sms#request).

2. If you need to use unicode, check if unicode is supported in the country you are sending to [Country Specific Features](#country-specific-features).

3. For messages where you have not set [type](/api/sms#parameters) to `text`, check that your user's handset supports the format. For example, a US handset may not display Arabic.
