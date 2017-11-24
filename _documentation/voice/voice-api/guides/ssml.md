---
title: SSML
---

# SSML

Nexmo's Voice API allows you to send text using a number of tags from the XML-based [Speech Synthesis Markup Language](https://www.w3.org/TR/speech-synthesis11/) (SSML). This enables you to mix multiple languages, to control the speed, volume and pitch of synthesised text, and to control pronunciation of words and numbers,.

In an [NCCO](/api/voice/ncco) `talk` action, you can send SSML tags as part of the text string. They must all be wrapped in a `speak` root tag. You may use either single quotes or escaped double quotes around attribute values on SSML tags.

### Language

The `lang` tag allows you to control the language used in the speech.

```xml
<speak><lang xml:lang='it'>Buongiorno</lang></speak>
```

### Breaks

The `break` tag allows you to add pauses to text. The duration of the pause can be specified either using a `strength` duration or as a `time` seconds or milliseconds.

```xml
<speak>My name is <break time='1s' /> Slim Shady.</speak>
```
Valid `strength` values include:
* `none` or `x-weak` (which removes a pause which might otherwise exist after a full stop)
* `weak` or `medium` (equivalent to a comma)
* `strong` or `x-strong` (equivalent to a paragraph break)

```xml
<speak>To be <break strength='weak' /> or not to be <break strength='weak' /> that is the question.</speak>
```

### Paragraphs

The `p` tag allows you to specify paragraphs in your speech.

```xml
<speak>
<p>It is a truth universally acknowledged, that a single man in possession of a good fortune must be in want of a wife.</p>
<p>However little known the feelings or views of such a man may be on his first entering a neighbourhood, this truth is so well fixed in the minds of the surrounding families, that he is considered the rightful property of some one or other of their daughters.</p>
</speak>
```

### Phonemes

The `phoneme` tag allows you to send an IPA representation of a word. To use this, you need to specify both an `alphabet` (either `ipa` or [`x-sampa`](https://en.wikipedia.org/wiki/X-SAMPA)) and the `ph` attribute containing the phonetic symbols.

```xml
<speak><phoneme alphabet='ipa' ph='təˈmætoː'>Tomato</phoneme> or <phoneme alphabet='ipa' ph='təˈmeɪtoʊ'>tomato</phoneme>. Two nations separated by a common language.</speak>
```

### Prosody

The `prosody` tag allows you to set the pitch, rate and volume of the text.

The `volume` attribute can be set to the following values: `default`, `silent`, `x-soft`, `soft`, `medium`, `loud` and `x-loud`. You can also specify a relative decibel value in the form `+ndB` or `-nDB` where `n` is an integer value.

The `rate` attribute changes the speed of speech. Acceptable values include: `x-slow`, `slow`, `medium`, `fast` and `x-fast`.

The `pitch` attribute changes the pitch of the voice. You can specify this using either predefined value labels or numerically. The value labels are: `default`, `x-low`, `low`, `medium`, `high` and `x-high`. The format for specifying a numerical pitch change is: `+n%` and `-n%`.

The example below shows how to change the volume, rate and pitch.

```xml
<speak>I am <prosody volume='loud'>loud and proud</prosody>, <prosody rate='fast'>quick as a cricket</prosody> and can <prosody pitch='x-low'>change my pitch</prosody>.</speak>
```

### Sentences

You can wrap sentences in the `s` tag. This is equivalent to putting a full stop at the end of the sentence.

```xml
<speak>
<s>Thank you Mario</s>
<s>But our princess is in another castle</s>
</speak>
```

## See also

* [SSML Tags in Amazon Polly](https://docs.aws.amazon.com/polly/latest/dg/supported-ssml.html) — full details of supported SSML tags
