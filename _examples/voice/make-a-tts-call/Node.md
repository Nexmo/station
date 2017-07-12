---
title: Node.js
language: node
---

Install the Nexmo Node library:

```bash
npm install nexmo
```

Create an `index.js`:

```js
const Nexmo = require('nexmo')

const nexmo = new Nexmo({
  apiKey: API_KEY,
  apiSecret: API_SECRET,
  applicationId: APPLICATION_ID,
  privateKey: PRIVATE_KEY
})

nexmo.calls.create({
  from: {
    type: 'phone',
    number: FROM_NUMBER
  },
  to: [{
    type: 'phone',
    number: TO_NUMBER
  }],
  answer_url: ['https://nexmo-community.github.io/ncco-examples/first_call_talk.json']
}, (error, response) => {
  if (error) {
    console.error(error)
  } else {
    console.log(response)
  }
})

```

Run the application:

```bash
node index.js
```
