---
title: SSML
---

# SSML

Nexmo's Voice API allows you to send text using a number of tags from the XML-based [Speech Synthesis Markup Language](https://www.w3.org/TR/speech-synthesis11/) (SSML). This enables you to mix multiple languages, to control the speed, volume and pitch of synthesised text, and to control pronunciation of words and numbers,.

In an [NCCO](/api/voice/ncco) `talk` action, you can send SSML tags as part of the text string. They must all be wrapped in a `speak` root tag. You may use either single quotes or escaped double quotes around attribute values on SSML tags.

The example below contains SSML tags setting both the language and speed of the synthesised speech.

```tabbed_examples
tabs:
  JSON:
    source: '_examples/voice/guides/ssml/basic.json'
```

## See also

* [SSML Tags in Amazon Polly](https://docs.aws.amazon.com/polly/latest/dg/supported-ssml.html) — full details of supported SSML tags
