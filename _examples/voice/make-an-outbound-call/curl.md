---
title: cURL
language: curl
---

Create a JWT for authentication using the Application ID and the Nexmo CLI:

```bash
APPLICATION_JWT="$(nexmo jwt:generate ./private.key application_id=NEXMO_APPLICATION_ID)"
```

Make a call:

```bash
curl -X POST https://api.nexmo.com/v1/calls\
  -H "Authorization: Bearer "$APPLICATION_JWT\
  -H "Content-Type: application/json"\
  -d '{"to":[{"type": "phone","number": TO_NUMBER}],
      "from": {"type": "phone","number": NEXMO_NUMBER},
      "answer_url":["https://developer.nexmo.com/ncco/tts.json"]}'
```
