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
        Log.d("TAG", "Error: Unable to start a call ${apiError.message}")
    }
}

val callEventListener = object : NexmoCallEventListener {
    override fun onDTMF(digit: String?, callMember: NexmoCallMember?) {
        Log.d("TAG", "v: digit: $digit, callMember: $callMember")
    }

    override fun onMemberStatusUpdated(memberStatus: NexmoCallMemberStatus?, callMember: NexmoCallMember?) {
        Log.d("TAG", "onMemberStatusUpdated: status: $memberStatus, callMember: $callMember")
    }

    override fun onMuteChanged(muteState: NexmoMediaActionState?, callMember: NexmoCallMember?) {
        Log.d("TAG", "onMuteChanged: muteState: $muteState, callMember: $callMember")
    }

    override fun onEarmuffChanged(earmuffState: NexmoMediaActionState?, callMember: NexmoCallMember?) {
        Log.d("TAG", "onEarmuffChanged: earmuffState: $earmuffState, callMember: $callMember")
    }
}


nexmoClient.call("123456", NexmoCallHandler.SERVER, callListener)
```
