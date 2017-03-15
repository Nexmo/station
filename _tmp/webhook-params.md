**URL Parameters**

Parameter | Description | Type | Example
-- | -- | -- | --
`msisdn` | Number that the message originated from | `string` | `447700900000`
`to` | Number that the message was sent to | `string` | `447700900000`
`messageId` |16 character long message ID string. | `string` | `0A12345678BC90D`
`text` | Body of the message | `string` | `Hello Nexmo!`
`message-timestamp` | Timestamp of when the message was received | `string` ([ISO 8601](https://en.wikipedia.org/wiki/ISO_8601)) | `2020-01-01 12:00:00`

**Headers**

Key | Value
-- | --
`Accept` | `*/*`
`User-Agent` | `Nexmo/MessagingHUB/v1.0`
