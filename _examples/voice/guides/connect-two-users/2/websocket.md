---
title: Websockets
menu_weight: 2
---

```json
[
  {
    "action": "talk",
    "text": "Please wait while we connect you"
  },
  {
    "action": "connect",
    "eventUrl": [
      "https://example.com/events"
    ],
    "from": "441632960960",
    "endpoint": [
    {
      "type": "websocket",
      "uri": "ws://example.com/socket",
      "content-type": "audio/l16;rate=16000",
      "headers": {
        "whatever": "metadata_you_want"
        }
      }
    ]
  }
]
```
