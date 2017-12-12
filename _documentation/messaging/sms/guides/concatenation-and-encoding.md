---
title: Concatenation & Encoding
---

# Concatenation & Encoding

When you send SMS with Nexmo you should be aware of how many parts your message is being sent as and what encoding is required to send your message.

## Overview

If you send a message that contains more than the maximum number of characters for your chosen encoding, Nexmo sends a concatenated SMS. A concatenated SMS contains multiple SMS parts that are connected by segmentation information in the User Data Header (UDH).

Segmentation information tells the handset the number of messages that make up the concatenated SMS, and the position of each SMS part in the concatenated SMS. The parts of a concatenated SMS arrive at the user's handset out of sequence. When the handset has received all the SMS parts, it presents your message as a single text to your user.

The maximum number of characters you can fit into an SMS part also depends on the Encoding that you are using.

## Maximum number of characters

If you are sending a message with type value of `text` then the following character limits apply:

| Parts | Maximum Characters | Calculation |
| -- | -- | -- |
| 1 | 160 | Without UDH 160 characters are available |
| 2 | 304 | `(160 - 8) * 2 = 304` |
| 3 | 456 | `(160 - 8) * 3 = 456` |
| 4 | 608 | `(160 - 8) * 4 = 608` |

If your SMS uses Unicode the amount of characters you can send per part depends on how many bytes the ligatures that you are sending require. Use this tool to test with your message templates:

```partial
source: app/views/tools/concatenation.html
```

Nexmo accepts SMS of up to 3200 characters but not all carriers do. It's best practice  that the message does not exceed 6 SMS parts.

> Note: You are charged for each SMS sent as part of a concatenated SMS.

# Encoding

By default all SMS sent by Nexmo are support the following characters:

````
! " # $ % ' ( ) * + , - . / : ; < = > ? @ _ ¡ £ ¥ § ¿
0 1 2 3 4 5 6 7 8 9
A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
a b c d e f g h i j k l m n o p q r s t u v w x y z
Ä Å Æ Ç É Ñ Ø Ü ß à ä å æ è é ì ñ ò ö ù ü
````

A message saying `Hello World`, `Bonjour monde` or `Hola mundo` is delivered seamlessly.

However, sending `Привет мир`, `שלום עולם` or `مرحبا بالعالم` requires more thought. Languages such as Arabic, Chinese, Korean, Japanese, or Cyrillic alphabet languages need the 16-bit characters available in Unicode.

## Inbound Messages

If you rent one or more virtual numbers from Nexmo, inbound SMS to that number are sent to your webhook endpoint using either GET or POST. Inbound messages comply with the SMS format. If an SMS sent to your virtual number is longer than the [maximum number of characters](#maximum-number-of-characters) for an individual SMS, you should receive the concatenated message in SMS parts.

You can use the `concat-ref`, `concat-total` and `concat-part` parameters to reassemble the parts into the message. However, you can only receive inbound concatenated SMS if the carrier your user is sending through supports them. If the carrier who sent the inbound SMS does not support concatenation, a workaround is to consider messages coming from the same number within a close time period as concatenated.
