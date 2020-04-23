---
title: Java
language: java
menu_weight: 5
---

```java
NexmoRequestListener<NexmoCall> callListener = new NexmoRequestListener<NexmoCall>() {
    @Override
    public void onSuccess(@Nullable NexmoCall nexmoCall) {
        Log.d("TAG", "Call started: " + nexmoCall.toString());
    }

    @Override
    public void onError(@NonNull NexmoApiError apiError) {
        Log.d("TAG", "Error: Unable to start a call " + apiError.getMessage());
    }
};

client.call("123456", NexmoCallHandler.SERVER, callListener)
```
