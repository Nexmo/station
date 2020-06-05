---
title: Java
language: java
---

```java
NexmoRequestListener<NexmoCall> hangupCallListener = new NexmoRequestListener<NexmoCall>() {
    @Override
    public void onSuccess(@Nullable NexmoCall nexmoCall) {
        Log.d("TAG", "Call hangup: " + nexmoCall);
    }

    @Override
    public void onError(@NonNull NexmoApiError apiError) {
        Log.d("TAG", "Error: Unable to hangup call " + apiError.getMessage());
    }
};

nexmoCall.hangup(hangupCallListener);
```
