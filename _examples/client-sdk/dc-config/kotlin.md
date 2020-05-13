---
title: Kotlin
language: kotlin
---

```kotlin
val nexmoClient = NexmoClient.Builder()
    .restEnvironmentHost("https://api-eu-1.nexmo.com")
    .environmentHost("https://ws-eu-1.nexmo.com")
    .imageProcessingServiceUrl("https://api-eu-1.nexmo.com/v1/image")
    .build(context)
```
