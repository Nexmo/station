---
title: Java
language: java
---

```java
NexmoIncomingCallListener incomingCallListener = new NexmoIncomingCallListener() {
    @Override
    public void onIncomingCall(NexmoCall call) {
        Log.d("TAG", "Incoming call " + call);

        call.answer(answerCallListener);
    }
};

NexmoRequestListener<NexmoCall> answerCallListener = new NexmoRequestListener<NexmoCall>() {
    @Override
    public void onSuccess(@Nullable NexmoCall nexmoCall) {
        Log.d("TAG", "Call answered: " + nexmoCall);
    }

    @Override
    public void onError(@NonNull NexmoApiError apiError) {
        Log.d("TAG", "Error: Unable to answer incoming call " + apiError.getMessage());
    }
};

NexmoClient client = NexmoClient.get();
client.addIncomingCallListener(incomingCallListener);
```
