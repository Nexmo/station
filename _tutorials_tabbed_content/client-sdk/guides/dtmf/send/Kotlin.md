---
title: Kotlin
language: kotlin
---

```kotlin
val callListener = object : NexmoRequestListener<NexmoCall> {
    override fun onSuccess(nexmoCall: NexmoCall?) {
        Log.d("TAG", "Call started: " + nexmoCall.toString())

        nexmoCall.sendDTMF("123456")
    }

    override fun onError(apiError: NexmoApiError) {
        Timber.d("Error: Unable to start a call ${apiError.message}")
    }
}

nexmoClient.call("123456", NexmoCallHandler.SERVER, callListener)
```
