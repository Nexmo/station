---
title: Authentication
---

# Authentication

Nexmo API provides various means of Authentication depending on what product you are using.

API | API Key & Secret | JSON Web Token (JWT) | OAuth
-- | -- | -- | --
SMS API | ✅ | ❎ | ✅
Conversion API | ✅ | ❎| ❎
Number Insight | ✅ | ❎| ❎
Developer API | ✅ | ❎| ❎
Voice API | ❎ | ✅ | ❎

## Contents

In this document you can learn about:

* [API Key & Secret](#api-key-secret)
* [JSON Web Tokens (JWT)](#json-web-tokens-jwt)
* [OAuth](#oauth)

## API Key & Secret

When you create a Nexmo account you will be provided an API key and secret. These can be found in your [account settings](https://dashboard.nexmo.com/settings) in the Nexmo Dashboard. The secret should always be kept secure and never shared: be careful when adding it to your codebase to make sure it is not shared with anyone who may use it maliciously.

The API key and secret should be included in the parameters of requests you make to the SMS, Conversion, Number Insight or Developer API.

## JSON Web Tokens (JWT)

JSON Web Tokens (JWT) are a compact, URL-safe means of representing claims to be transferred between two parties.

JWTs are supported by the Voice API as a means of authenticating your requests. The [Nexmo libraries](/tools) and CLI handle JWT generation using a unique Nexmo Voice Application ID and a Private Key.

If you are not using a Nexmo library you should refer to [RFC 7519](https://tools.ietf.org/html/rfc7519) to implement JWT.

## OAuth

Some Nexmo APIs support OAuth as a means of authenticating. We provide an in-depth guide on how to authenticate with OAuth [here](/concepts/guides/oauth).

## References

* [Voice API Reference](/api/voice)
* [SMS API Reference](/api/sms)
