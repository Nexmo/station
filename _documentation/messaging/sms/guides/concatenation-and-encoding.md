---
title: Concatenation and Encoding
---

# Concatenation and Encoding

When you send an SMS with Nexmo you should be aware of how many parts your message is being sent as and what encoding is required to send your message.

## Overview

If you send a message that contains more than the maximum number of characters for your chosen encoding, Nexmo sends a concatenated SMS. A concatenated SMS contains multiple SMS parts that are connected by segmentation information in the User Data Header (UDH).

Segmentation information tells the handset the number of messages that make up the concatenated SMS, and the position of each SMS part in the concatenated SMS. The parts of a concatenated SMS arrive at the user's handset out of sequence. When the handset has received all the SMS parts, it presents your message as a single text to your user.

The maximum number of characters you can fit into an SMS part also depends on the [Encoding](#encoding) that you are using.

## Maximum number of characters

If you are sending a message with type value of `text` then the following character limits apply:

| Parts | Maximum Characters | Calculation |
| -- | -- | -- |
| 1 | 160 | Without UDH 160 characters are available |
| 2 | 304 | `(160 - 8) * 2 = 304` |
| 3 | 456 | `(160 - 8) * 3 = 456` |
| 4 | 608 | `(160 - 8) * 4 = 608` |

If your SMS uses Unicode the number of characters you can send per part depends on how many bytes the ligatures that you are sending require. Use this tool to test with your message templates:

```partial
source: app/views/tools/concatenation.html
```

Nexmo accepts SMS of up to 3200 characters but not all carriers do. It's best practice to ensure that the message does not exceed six SMS parts.

> Note: You are charged for each SMS sent as part of a concatenated SMS.

## Inbound Messages

If you rent one or more virtual numbers from Nexmo, inbound SMS to that number are sent to your webhook endpoint using either GET or POST. Inbound messages comply with the SMS format. If an SMS sent to your virtual number is longer than the [maximum number of characters](#maximum-number-of-characters) for an individual SMS, you should receive the concatenated message in SMS parts.

You can use the `concat-ref`, `concat-total` and `concat-part` parameters to reassemble the parts into the message. However, you can only receive inbound concatenated SMS if the carrier your user is sending through supports them. If the carrier who sent the inbound SMS does not support concatenation, a workaround is to consider messages coming from the same number within a close time period as concatenated.

# Encoding

## GSM character set

Nexmo supports the standard GSM characters as well as characters from the GSM extended table. Characters from the standard table require 7-bits per character to encode:

````
! " # $ % ' ( ) * + , - . / : ; < = > ? @ _ ¡ £ ¥ § ¿ & ¤ §
0 1 2 3 4 5 6 7 8 9
A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
a b c d e f g h i j k l m n o p q r s t u v w x y z
Ä Å Æ Ç É Ñ Ø ø Ü ß Ö à ä å æ è é ì ñ ò ö ù ü Δ Φ Γ Λ Ω Π Ψ Σ Θ Ξ
````

Characters from the [extended table](https://en.wikipedia.org/wiki/GSM_03.38#GSM_7-bit_default_alphabet_and_extension_table_of_3GPP_TS_23.038_/_GSM_03.38) require two bytes per character to encode, the first prefix character is ESC followed by the character from the extended table:

````
| ^ € { } [ ] ~ \
````

## Unicode

Languages such as Arabic, Chinese, Korean, Japanese, or Cyrillic alphabet languages require Unicode characters beyond the standard GSM and ANSI ranges. These characters typically use 16-bit UCS-2 encoding.

Note that even if only one Unicode character is used in the message that cannot be encoded in a single byte, then all characters in the message will automatically be encoded using two-bytes per character.

## Examples

A message containing `Hello World`, `Bonjour monde` or `Hola mundo` is encoded using standard GSM characters at 7-bits per character.

Messages such as `Привет мир`, `שלום עולם` or `مرحبا بالعالم` will automatically result in Unicode characters being used at 16-bits per character for every character.

