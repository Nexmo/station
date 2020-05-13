---
title: Kotlin
language: kotlin
---

```kotlin
private val memberEventListener = object : NexmoMemberEventListener {
    override fun onMemberInvited(memberEvent: NexmoMemberEvent) {
        Log.d("TAG", "Member ${memberEvent.member.user.name} invited to the conversation")
        
        // Join user to the conversation (accept the invitation)
        conversation?.join(memberEvent.member.user.name, joinConversationListener)
    }

    override fun onMemberAdded(memberEvent: NexmoMemberEvent) {}
    
    override fun onMemberRemoved(memberEvent: NexmoMemberEvent) {}
}

private val joinConversationListener = object: NexmoRequestListener<String>{
    override fun onSuccess(memberId: String?) {
        Log.d("TAG", "Member joined the conversation $memberId")
    }

    override fun onError(apiError: NexmoApiError) {
        Log.d("TAG", "Error: Unable to join member to the conversation $apiError")
    }
}

conversation?.addMemberEventListener(memberEventListener)
```
