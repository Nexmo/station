---
title: Kotlin
language: kotlin
menu_weight: 4
---

```kotlin
val callListener = object: NexmoRequestListener<NexmoCall> {
    override fun onSuccess(nexmoCall: NexmoCall?) {
        Log.d("TAG", "Call started: ${nexmoCall.toString()}")
    }

    override fun onError(apiError: NexmoApiError) {
        Log.d("TAG", "Error: Unable to start a call ${apiError.message}")
    }
}

client.call("123456", NexmoCallHandler.SERVER, callListener);

```
