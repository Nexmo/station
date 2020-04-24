---
title: Kotlin
language: kotlin
---

```kotlin
val hangupCallListener = object: NexmoRequestListener<NexmoCall> {
    override fun onSuccess(nexmoCall: NexmoCall?) {
        Log.d("TAG", "Call hangup: $nexmoCall")
    }

    override fun onError(apiError: NexmoApiError) {
        Log.d("TAG", "Error: Unable to hangup call ${apiError.message}")
    }
}

nexmoCall.hangup(hangupCallListener)
```
