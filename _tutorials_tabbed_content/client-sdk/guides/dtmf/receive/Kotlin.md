---
title: Kotlin
language: kotlin
---

The DTMF events will be received in your implementation of `NexmoCallEventListener.onDTMF()` method, on the `NexmoCallEventListener` that is attached to the `NexmoCall`.

```kotlin
val callListener = object : NexmoRequestListener<NexmoCall> {
    override fun onSuccess(nexmoCall: NexmoCall?) {
        Log.d("TAG", "Call started: " + nexmoCall.toString())

        nexmoCall?.addCallEventListener(callEventListener)
    }

    override fun onError(apiError: NexmoApiError) {
        Timber.d("Error: Unable to start a call ${apiError.message}")
    }
}

val callEventListener = object : NexmoCallEventListener {
    override fun onDTMF(digit: String?, callMember: NexmoCallMember?) {
        Timber.d("v: digit: $digit, callMember: $callMember")
    }

    override fun onMemberStatusUpdated(memberStatus: NexmoCallMemberStatus?, callMember: NexmoCallMember?) {
        Timber.d("onMemberStatusUpdated: status: $memberStatus, callMember: $callMember")
    }

    override fun onMuteChanged(muteState: NexmoMediaActionState?, callMember: NexmoCallMember?) {
        Timber.d("onMuteChanged: muteState: $muteState, callMember: $callMember")
    }

    override fun onEarmuffChanged(earmuffState: NexmoMediaActionState?, callMember: NexmoCallMember?) {
        Timber.d("onEarmuffChanged: earmuffState: $earmuffState, callMember: $callMember")
    }
}


nexmoClient.call("123456", NexmoCallHandler.SERVER, callListener)
```
