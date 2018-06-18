---
title: Write the docs
navigation_weight: 2
---

# Write the docs

These are technical writing guidelines that can be used across all Nexmo technical documentation as well as blog posts.

These guidelines are designed to improve clarity and consistency.

As with most guidelines these are suggestions to help improve clarity and consistency, not hard and fast rules. Use your best judgement.

### Use present tense

Use present tense. It’s easier to read and translate.

> *Future:* Command X will start the server.

> *Present:* Command X starts the server.

### Use simple language

Use clear, simple, and direct language. Avoid flowery and verbose writing styles.

### Use active voice

Use active voice. For example:

> *Active voice:* The man ate the apple.

> *Passive voice:* The apple was eaten by the man.

### Paragraph breaks

In technical writing, and especially blog posts, you can be a little more generous with your use of paragraph breaks. They make the text less overwhelming and easier to read.

### Avoid vague and cautious language

Avoid words like would, should, might and so on.

> *Avoid:* If you run the Nexmo CLI with no parameters you might see some text, or possibly an error, or something!

> *Better:* If you run the Nexmo CLI without specifying parameters a help message is displayed.

### Use second person

Use 'you' rather than 'we'. 

> You can now click the button to register your Nexmo Number.

Use Nexmo rather than 'we'. 

> *Avoid:* We also provide an SMS API.

> *Better:* Nexmo also provides an SMS API.

### Use American English

The company standard is, as with most software companies, to use American English.

The industry standard dictionary is Merriam Webster.

### Avoid Latin phrases and slang

Latin phrases and abbreviations can sometimes cause confusion. They can also be less convenient to translate.

* Use ‘for example’, instead of 'e.g.' and 'that is' rather than 'i.e.'. 
* Don't use words like 'crash', use 'error'. Use launch or start rather than 'fire up'.
* Bear in mind the reader’s first language may not be English.
* Mouse is clicked and keyboard is pressed. Avoid terms such as `hit` when referring to the keyboard.

### Headings

Use sentence case for section headings. For example, 'This is a section heading'.

### Bulleted lists

This is an example of a bulleted list:

* Precede a list with a sentence and a colon.
* Terminate each sentence in a list with a full stop.
* Use bulleted lists for lists.
* Use numbered lists for ordered sequences (procedures, tasks and so on).

### Codeblocks

* Specify the coding language where possible.
* Break text before codeblock with colon, not period (which is a hard stop in the mind of the reader, rather than a continuation). Also, there should not be a space before the colon.

### Three Letter Acronyms (TLAs)

Define Three Letter Acronyms (TLAs) before first use. On subsequent use on a page/section you do not need to redefine the TLA.

### Be explicit

Try to be explicit, that is use precise terms where necessary to improve clarity and avoid ambiguity. 

Examples of being more explicit:

* Use 'Nexmo Number' rather than 'number'.
* Use 'Nexmo Application' rather than 'application'.
* Use 'webhook server' rather than 'server'.
* Use 'web application' rather than 'application'.
* Use 'webhook URL' rather than 'endpoint' or 'callback URL'.
* Use Nexmo Client Library rather than 'library'.
* Use Nexmo Command Line Interface, or Nexmo CLI, rather than 'command line'.

### Miscellaneous

Some additional points to bear in mind:

* Try to explain to the reader *why* they need a particular feature and not just what the feature is.
* Avoid "He or she" (use user/developer as appropriate).
* Avoid filler words superfluous adjectives 'really nice feature', 'easily', ‘simple’, 'it may be that', 'and that's it'.
* Avoid subjective phrases. "You can easily...". "It is simple to...".
* Avoid statements that predict the future, for example, "the next version will have super xxx feature...". There are good legal reasons for avoiding predicting the future.
* Avoid time sensitive information. Specify an exact version where possible, for example '1.1', rather than 'current version' as the current version may change.
* Avoid using ampersand instead of 'and', unless you are specifying a programming language operator or similar.

### Replaceable values

When working with keys, phone numbers, or accounts be clear where values should be replaced by customer-specific values. 

Key | Markdown Value | Rendered Value  <small>(if different)</small>
-- | -- | --
Timestamp | `2020-01-01 12:00:00` | -
ISO8601 Timestamp | `2020-01-01T12:00:00.000Z` | -
Epoch | `1577880000` | -
HTTP Method | ``[GET]`` or ``[POST]`` | [GET] or [POST]
HTTP Response | `` `200 OK` `` or §§ `` `404 Not Found` `` | `200 OK` or §§ `404 Not Found`
Balance | `3.14159` | -
Latency | `3000` | -
UUID | `aaaaaaaa-bbbb-cccc-dddd-0123456789ab` | -
SNS ARN | `arn:aws:sns:us-east-1:01234567890:example` | -

### Numbers

When use of a real phone number can't be avoided, for example when listing out the result of `nexmo numbers:list` in the CLI, use the following numbers:

#### US Numbers

Human readable format | E.164 format
-- | --
`(415) 555-0100` | `14155550100`
`(415) 555-0101` | `14155550101`
`(415) 555-0102` | `14155550102`
`(415) 555-0103` | `14155550103`
`(415) 555-0104` | `14155550104`
`(415) 555-0105` | `14155550105`

#### GB Numbers

Human readable format | E.164 format
-- | --
`020 7946 0000` | `442079460000`
`020 7946 0001` | `442079460001`
`020 7946 0002` | `442079460002`
`020 7946 0003` | `442079460003`
`020 7946 0004` | `442079460004`
`020 7946 0005` | `442079460005`

#### GB Mobile Numbers

Human readable format | E.164 format
-- | --
`07700 900000` | `447700900000`
`07700 900001` | `447700900001`
`07700 900002` | `447700900002`
`07700 900003` | `447700900003`
`07700 900004` | `447700900004`
`07700 900005` | `447700900005`

### Examples of writing style guides

Some further examples of writing style guides are:

* [Microsoft Style for Technical Publications](https://books.google.co.uk/books/about/The_Microsoft_Manual_of_Style_for_Techni.html)
* [Magento](http://devdocs.magento.com/guides/v2.0/contributor-guide/contributing_docs.html)
* [Kubernetes](https://kubernetes.io/docs/home/contribute/style-guide/)
* [.NET](https://github.com/dotnet/docs/blob/master/styleguide/voice-tone.md)
