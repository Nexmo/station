---
title: Kotlin
language: kotlin
---

```kotlin
val incomingCallListener = NexmoIncomingCallListener {
    Log.d("TAG", "Incoming call $it")
}

val client = NexmoClient.get()
client.addIncomingCallListener(incomingCallListener)

```

Remove the listener when needed:

```kotlin
client.removeIncomingCallListeners()
```
