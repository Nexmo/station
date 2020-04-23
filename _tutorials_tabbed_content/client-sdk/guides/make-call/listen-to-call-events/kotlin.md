---
title: Kotlin
language: kotlin
---

```kotlin
val callEventListener = object : NexmoCallEventListener {
    override fun onDTMF(digit: String?, callMember: NexmoCallMember?) {
        Log.d("TAG", "IncomingCallActivity:onDTMF(): digit: $digit, callMember: $callMember")
    }

    override fun onMemberStatusUpdated(memberStatus: NexmoCallMemberStatus?, callMember: NexmoCallMember?) {
        Log.d("TAG", "IncomingCallActivity:onMemberStatusUpdated(): status: $memberStatus, callMember: $callMember")
    }

    override fun onMuteChanged(muteState: NexmoMediaActionState?, callMember: NexmoCallMember?) {
        Log.d("TAG", "IncomingCallActivity:NexmoMediaActionState(): muteState: $muteState, callMember: $callMember")
    }

    override fun onEarmuffChanged(earmuffState: NexmoMediaActionState?, callMember: NexmoCallMember?) {
        Log.d("TAG", "IncomingCallActivity:onEarmuffChanged(): earmuffState: $earmuffState, callMember: $callMember")
    }
}

nexmoCall?.addCallEventListener(callEventListener)
```

Remove the listener when needed:

```kotlin
nexmoCall?.removeCallEventListener(callEventListener)
```
