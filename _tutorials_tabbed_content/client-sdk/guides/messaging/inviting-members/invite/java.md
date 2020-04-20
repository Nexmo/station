---
title: Java
language: java
---

```java
conversation.invite(userName, new NexmoRequestListener<String>() {
    @Override
    public void onSuccess(@Nullable String result) {
        Log.d("TAG", "User invited " + result);
    }

    @Override
    public void onError(@NonNull NexmoApiError apiError) {
        Log.d("TAG", "Error: Unable to invite user " + apiError.getMessage());
    }   
});
```
