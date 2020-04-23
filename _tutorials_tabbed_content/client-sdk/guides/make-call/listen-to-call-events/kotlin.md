---
title: Kotlin
language: kotlin
---

```kotlin
val callEventListener = object : NexmoCallEventListener {
    override fun onDTMF(digit: String?, callMember: NexmoCallMember?) {
        Log.d("TAG", "onDTMF(): digit: $digit, callMember: $callMember")
    }

    override fun onMemberStatusUpdated(memberStatus: NexmoCallMemberStatus?, callMember: NexmoCallMember?) {
        Log.d("TAG", "onMemberStatusUpdated(): status: $memberStatus, callMember: $callMember")
    }

    override fun onMuteChanged(muteState: NexmoMediaActionState?, callMember: NexmoCallMember?) {
        Log.d("TAG", ":NexmoMediaActionState(): muteState: $muteState, callMember: $callMember")
    }

    override fun onEarmuffChanged(earmuffState: NexmoMediaActionState?, callMember: NexmoCallMember?) {
        Log.d("TAG", "onEarmuffChanged(): earmuffState: $earmuffState, callMember: $callMember")
    }
}

nexmoCall?.addCallEventListener(callEventListener)
```

Remove the listener when needed:

```kotlin
nexmoCall?.removeCallEventListener(callEventListener)
```
