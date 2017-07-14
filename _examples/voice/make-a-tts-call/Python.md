---
title: Python
language: python
---

Install the Nexmo Python package:

```bash
pip install nexmo
```

Create a `call.py`:

```python
import nexmo

PRIVATE_KEY = open(PRIVATE_KEY_PATH, 'r').read()
client = nexmo.Client(key=API_KEY, secret=API_SECRET,
    application_id=APPLICATION_ID, private_key=PRIVATE_KEY)

response = client.create_call({
  'to': [{'type': 'phone', 'number': 'TO_NUMBER'}],
  'from': {'type': 'phone', 'number': 'FROM_NUMBER'},
  'answer_url': ['https://nexmo-community.github.io/ncco-examples/first_call_talk.json']
})
```

Run:

```bash
python call.py
```
