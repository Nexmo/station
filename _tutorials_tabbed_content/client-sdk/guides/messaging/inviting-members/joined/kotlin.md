---
title: Kotlin
language: kotlin
---

```kotlin

private val memberEventListener = object : NexmoMemberEventListener {
    override fun onMemberInvited(memberEvent: NexmoMemberEvent) {}

    override fun onMemberAdded(memberEvent: NexmoMemberEvent) {
        Log.d("TAG", "Member ${memberEvent.member.user.name} added to the conversation")
    }

    override fun onMemberRemoved(memberEvent: NexmoMemberEvent) {}
}

conversation?.addMemberEventListener(memberEventListener)
```
