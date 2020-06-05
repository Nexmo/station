---
title: Kotlin
language: kotlin
---

```kotlin
val callEventListener = object : NexmoCallEventListener {
    // ...
}

nexmoCall.addCallEventListener(callEventListener)
```

Remove the listener when needed:

```kotlin
nexmoCall?.removeCallEventListener(callEventListener)
```
