---
title: Java
language: java
---

```java
NexmoRequestListener<NexmoCall> callListener = new NexmoRequestListener<NexmoCall>() {
    @Override
    public void onSuccess(@Nullable NexmoCall nexmoCall) {
        Log.d("TAG", "Call started: " + nexmoCall.toString());

        nexmoCall.sendDTMF("123456");
    }

    @Override
    public void onError(@NonNull NexmoApiError apiError) {
        Log.d("TAG", "Error: Unable to start a call " + apiError.getMessage());
    }
};

nexmoClient.call("123456", NexmoCallHandler.SERVER, callListener);
```
