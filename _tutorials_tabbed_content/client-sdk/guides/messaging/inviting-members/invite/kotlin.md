---
title: Kotlin
language: kotlin
---

```kotlin
conversation.invite(userName,  object: NexmoRequestListener<String>{
    override fun onSuccess(result: String?) {
        Log.d("TAG", "User invited $result")
    }

    override fun onError(apiError: NexmoApiError) {
        Log.d("TAG", "Error: Unable to invite user ${apiError.message}")
    }
})
```
