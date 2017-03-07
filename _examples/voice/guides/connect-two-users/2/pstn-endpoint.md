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
    "from": "441632960977",
     "endpoint": [
      {
        "type": "phone",
        "number": "441632960960"
      }
    ]
  }
]
```
