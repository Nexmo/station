---
title: Kotlin
language: kotlin
---

```kotlin
val incomingCallListener = NexmoIncomingCallListener {
    Log.d("TAG", "Incoming call $it")

    it.answer(answerCallListener)
}

val answerCallListener = object: NexmoRequestListener<NexmoCall> {
    override fun onSuccess(nexmoCall: NexmoCall?) {
        Log.d("TAG", "Call answered: $nexmoCall")
    }

    override fun onError(apiError: NexmoApiError) {
        Log.d("TAG", "Error: Unable to answer incoming call ${apiError.message}")
    }
}

val client = NexmoClient.get()
client.addIncomingCallListener(incomingCallListener)
```
