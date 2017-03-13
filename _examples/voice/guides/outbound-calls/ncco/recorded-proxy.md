---
title: Recorded proxy
menu_weight: 2
---

```json
[
  {
    "action": "record",
    "eventUrl": ["https://example.com/recordings"],
    "endOnSilence": "3"
  },
  {
    "action": "connect",
    "eventUrl": ["https://example.com/events"],
    "from":"447700900000",
    "endpoint": [
      {
        "type": "phone",
        "number": "447700900001"
      }
    ]
  }
]
```
