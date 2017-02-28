---
title: Websocket
menu_weight: 2
---

```json
{
  "to":[{
    "type": "websocket",
    "uri": "ws://example.com/socket",
    "content-type": "audio/l16;rate=16000",
    "headers": {
       "whatever": "metadata_you_want"
    }
  }],
  "from": {
    "type": "phone",
    "number": "441632960960"
  },
  "answer_url": ["http://example.com/answer"],
}
```
