---
title: Java
language: java
---

```java
NexmoRequestListener<NexmoCall> callListener = new NexmoRequestListener<NexmoCall>() {
    @Override
    public void onSuccess(@Nullable NexmoCall nexmoCall) {
        Log.d("TAG", "Call started: " + nexmoCall.toString());

        nexmoCall.addCallEventListener(callEventListener);
    }

    @Override
    public void onError(@NonNull NexmoApiError apiError) {
        Log.d("TAG", "Error: Unable to start a call " + apiError.getMessage());
    }
};

NexmoCallEventListener callEventListener = new NexmoCallEventListener() {

    @Override
    public void onMemberStatusUpdated(NexmoCallMemberStatus $memberStatus, NexmoCallMember callMember) {}

    @Override
    public void onMuteChanged(NexmoMediaActionState muteState, NexmoCallMember callMember) {}

    @Override
    public void onEarmuffChanged(NexmoMediaActionState earmuffState, NexmoCallMember callMember) {}

    @Override
    public void onDTMF(String digit, NexmoCallMember callMember) {
        Log.d("TAG", "onDTMF(): digit:" + digit + ", callMember: " + callMember);
    }
};

nexmoClient.call("123456", NexmoCallHandler.SERVER, callListener);
```
