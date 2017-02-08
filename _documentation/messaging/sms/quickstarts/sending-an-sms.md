---
title: Sending an SMS
navigation_weight: 1
---

# Sending an SMS

Sending an SMS with Nexmo is easy. Simply [sign up for an account](https://dashboard.nexmo.com/sign-up) and replace the following variables in the example below:

| Variable | Description |
| -------- | ----------- |
| `to` | The number you are sending the SMS to |
| `api_key` | You can find this in your [account overview](https://dashboard.nexmo.com/account-overview) |
| `api_secret` | You can find this in your [account overview](https://dashboard.nexmo.com/account-overview) |

```sh
curl -X "POST" "https://rest.nexmo.com/sms/json" \
  -d "from=Nexmo" \
  -d "text=A text message sent using the Nexmo SMS API" \
  -d "to=TO_NUMBER" \
  -d "api_key=API_KEY" \
  -d "api_secret=API_SECRET"
```
