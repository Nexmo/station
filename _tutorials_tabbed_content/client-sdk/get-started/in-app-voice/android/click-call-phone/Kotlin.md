---
title: Kotlin
navigation_weight: 0
---

```java
fun onPhoneCallClick(view: View) {
        val callee = listOf(CALLEE_PHONE_NUMBER) //TODO: swap with your phone number
        NexmoClient.get().call(callee, NexmoCallHandler.SERVER, callListener)
    }
```
