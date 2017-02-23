---
title: Call
menu_weight: 1
---

```
[
  {
      "action": "talk",
      "text": "Please leave a message after the tone, then press #. We will get back to you as soon as we can",
      "voiceName": "Emma"
  },
  {
      "action": "record",
      "eventUrl": [
          "http://myrecordings/voicemails"
      ],
      "endOnSilence": "3",
      "endOnKey" : "#",
      "beepStart": "true"
  },
  {
      "action": "talk",
      "text": "Thank you for your message. Goodbye"
  }
]
```
