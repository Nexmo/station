---
title: Kotlin
language: kotlin
---

```kotlin
conversation.invite(userName,  object: NexmoRequestListener<String>{
    override fun onSuccess(result: String?) {
        Timber.d("User invited $result")
    }

    override fun onError(apiError: NexmoApiError) {
        Timber.d("Error: Unable to invite user ${apiError.message}")
    }
})
```
