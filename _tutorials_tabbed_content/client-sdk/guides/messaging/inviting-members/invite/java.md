---
title: Java
language: java
---

```java
conversation.invite(userName, new NexmoRequestListener<String>() {
    @Override
    public void onSuccess(@Nullable String result) {
        Timber.d("User invited " + result);
    }

    @Override
    public void onError(@NonNull NexmoApiError apiError) {
        Timber.d("Error: Unable to invite user " + apiError.getMessage());
    }
});
```
