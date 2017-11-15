---
title: Authentication
---

# Authentication

Nexmo API provides various means of Authentication depending on what product you are using.

API | API Key & Secret | JSON Web Token (JWT) | OAuth
-- | -- | -- | --
[SMS](/api/sms) | ✅ | ❎ | ✅
[Voice](/api/voice) | ❎ | ✅ | ❎
[Verify](/api/verify) | ✅ | ❎| ❎
[Number Insight](/api/number-insight) | ✅ | ❎| ❎
[Conversion](/api/conversion) | ✅ | ❎| ❎
[Developer](/api/developer) | ✅ | ❎| ❎

## Contents

In this document you can learn about:

* [API Key & Secret](#api-key-secret)
* [JSON Web Tokens (JWT)](#json-web-tokens-jwt)
* [OAuth](#oauth)

## API Key & Secret

When you create a Nexmo account you will be provided an API key and secret. These can be found in your [account settings](https://dashboard.nexmo.com/settings) in the Nexmo Dashboard.

> Note: The secret should always be kept secure and never shared. Be careful when adding it to your codebase to make sure it is not shared with anyone who may use it maliciously. Read more about the [Best Security Practices for your Nexmo Account](https://help.nexmo.com/hc/en-us/articles/115014939548).

The API key and secret should be included in the parameters of requests you make to the SMS, Conversion, Number Insight or Developer API.

## JSON Web Tokens (JWT)

JSON Web Tokens (JWT) are a compact, URL-safe means of representing claims to be transferred between two parties.

JWTs are supported by the Voice API as a means of authenticating your requests. The [Nexmo libraries](/tools) and CLI handle JWT generation using a unique Nexmo Voice Application ID and a Private Key.

Values for the Header are:

Name | Description | Required
-- | -- | --
`alg` | The encryption algorithm used to generate the JWT. `RS256` is supported. | ✅
`typ` | The token structure. Set to `JWT`. | ✅

The values for the payload claim are:

Name | Description | Required
-- | -- | --
`application_id` | The unique ID allocated to your application by Nexmo. | ✅
`iat` | The UNIX timestamp at UTC + 0 indicating the moment the JWT was requested. | ✅
`jti` | The unique ID of the JWT. | ✅
`nbf` | The UNIX timestamp at UTC + 0 indicating the moment the JWT became valid. | ❎
`exp` | The UNIX timestamp at UTC + 0 indicating the moment the JWT is no longer valid. Minimum time of 30 seconds from the time the JWT is generated. Maximim value of 24 hours from the time the JWT is generated. Default value of 15 minutes from the time the JWT is generation. | ❎

If you are not using a Nexmo library you should refer to [RFC 7519](https://tools.ietf.org/html/rfc7519) to implement JWT.

## OAuth

Some Nexmo APIs support OAuth as a means of authenticating. We provide an in-depth guide on how to authenticate with OAuth [here](/concepts/guides/oauth).

## References

* [Voice API Reference](/api/voice)
* [SMS API Reference](/api/sms)
