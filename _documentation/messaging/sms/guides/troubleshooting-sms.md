---
title: Troubleshooting Failed SMS
---

# Troubleshooting Failed SMS

When you [send an SMS](/messaging/sms/building-blocks/send-an-sms), the SMS API returns a JSON response that contains an array of `message` objects, one for each message:

```json
{
    "message-count": "1",
    "messages": [
        {
            "to": "447700900000",
            "message-id": "0C000000217B7F02",
            "status": "0",
            "remaining-balance": "15.53590000",
            "message-price": "0.03330000",
            "network": "23410"
        }
    ]
}
```

The `status` field tells you if the message was successfully queued for sending. A non-zero value indicates a failure.

> Note: A `status` of zero in the API response does not indicate that Nexmo delivered your message. See [What else could have gone wrong?](#what-else-could-have-gone-wrong)

## SMS API error codes

If the SMS API returns a non-zero `status` value then use the following table to determine what went wrong:

| `status` | Meaning | Description |
|---|---|---|
| 1 | Throttled | You are sending SMS faster than the account limit (see [What is the Throughput Limit for Outbound SMS?](https://help.nexmo.com/hc/en-us/articles/203993598)). |
| 2 | Missing Parameters | Your request is missing one of the required parameters: `from`, `to`, `api_key`, `api_secret` or `text`. |
| 4 | Invalid Credentials | Your API key and/or secret are incorrect. |
| 6 | Unroutable | Nexmo cannot reach your destination. Possible reasons might be that you have specified an invalid `to` number (perhaps without the international code), or that the number is a landline. |
| 8 | Partner Account Barred  | Your Nexmo account has been suspended. Contact <support@nexmo.com>. |
| 9 | Partner Quota Violation  | You do not have sufficient credit to send the message. Top-up and retry.  |
| 14 | Invalid Sender  | You are using a non-authorized sender ID in the `from` field. This is most commonly in North America, where a Nexmo long virtual number or short code is required.  |
| 29 | Non-Whitelisted Destination  | Your Nexmo account is still in demo mode. While in demo mode you must add target numbers to your whitelisted destination list. Top-up your account to remove this limitation. |

## What else could have gone wrong?

If the value of `status` is zero and your message still did not arrive, then something went wrong during the actual delivery process. To know if your message reached the intended recipient, you need a [delivery receipt](/messaging/sms/guides/delivery-receipts) from the carrier.

