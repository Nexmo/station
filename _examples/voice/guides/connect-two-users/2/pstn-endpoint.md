---
title: PSTN endpoint
menu_weight: 1
---

```json
[
  {
    "action": "talk",
    "text": "Please wait while we connect you"
  },
  {
    "action": "connect",
    "eventUrl": ["https://example.com/events","https://example.com/backup"],
    "timeout": "45",
    "from": "447700900007",
     "endpoint": [
      {
        "type": "phone",
        "number": "447700900000"
      }
    ]
  }
]
```
