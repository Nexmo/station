---
title: Signed webhooks
description: Verify the source of incoming requests via the Messages API.
navigation_weight: 4
---

# Signing webhooks

Signed webhooks provide a method for your application to verify a request is coming from Vonage and its payload has not been tampered with during transit. When receiving a request, the incoming webhook will include a JWT token in the authorization header which is signed with your signature secret. The secret used to sign the request corresponds to the signature secret associated with the `apikey` included in the JWT claims.

You use a signature to:

* Verify that a request originates from a trusted source
* Ensure that the message has not been tampered with en-route
* Defend against interception and later replay

## Validate the signature on incoming messages

Webhooks for both inbound messages and message status will include a JWT in the authorization header. Use the API key included in the JWT claims to identify which of your signature secrets has been used to sign the request. Once you have verified the authenticity of the request, you can verify the request payload has not been tampered with by comparing a `sha_256` hash of the payload to the `payload_hash` field found in the JWT claims. If they do not match, then the payload has been tampered with during transit.

In the rare case of an Internal Error, it is possible that the Callback Service will send an unsigned callback. By returning an HTTP 5xx response, a retry will be triggered giving the system time to resolve the error and sign future callbacks.

The code example below shows how to verify a webhook signature. We recommend using HTTPS protocol as it ensures that the request & response are encrypted on the both (client & server) the ends.

```code_snippets
source: '_examples/messages/signed-webhooks'
```

## Sample Signed JWT

```json
{
  "alg": "HS256",
  "typ": "JWT",
}
// body
{
  "iat": 1587494962,
  "jti": "c5ba8f24-1a14-4c10-bfdf-3fbe8ce511b5",
  "iss": "Vonage",
  "payload_hash" : "d6c0e74b5857df20e3b7e51b30c0c2a40ec73a77879b6f074ddc7a2317dd031b",
  "api_key": "a1b2c3d",
  "application_id": "123456-abcdef-7891011"
}
```

### Header

Header | Value
-- | --
`alg` | HS256
`typ` | JWT

### Payload

Field | Value | Description
--- | --- | ---
`iat` |  Unix timestamp in SECONDS | The time at which the JWT was issued.
`jti` | Newly generated UUID | A unique id for the JWT.
`iss` | Vonage | The issuer of the JWT. This will always be 'Vonage'.
`payload_hash` | sha256 text or JSON body | A sha256 hash of the request payload. Can be compared to the request payload to ensure it has not been tampered with during transit.
`api_key` | a1b2c3d | The API key associated with the account that made the original request.
`application_id` | appId1 | (Optional) The id of the application that made the original request if an application was used.
