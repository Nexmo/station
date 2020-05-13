---
title: Java
language: java
---

```java
NexmoCallEventListener callEventListener = new NexmoCallEventListener() {
    @Override
    public void onMemberStatusUpdated(NexmoCallMemberStatus $memberStatus, NexmoCallMember callMember) {
        Log.d("TAG", "onMemberStatusUpdated(): status: " + $memberStatus + " callMember: " + callMember);
    }

    @Override
    public void onMuteChanged(NexmoMediaActionState muteState, NexmoCallMember callMember) {
        Log.d("TAG", "NexmoMediaActionState(): muteState: " + muteState + ", callMember: " + callMember);
    }

    @Override
    public void onEarmuffChanged(NexmoMediaActionState earmuffState, NexmoCallMember callMember) {
        Log.d("TAG", "onEarmuffChanged(): earmuffState: " + earmuffState + ", callMember: " + callMember);
    }

    @Override
    public void onDTMF(String digit, NexmoCallMember callMember) {
        Log.d("TAG", "onDTMF(): digit:" + digit + ", callMember: " + callMember);
    }
};

nexmoCall.addCallEventListener(callEventListener);
```

Remove the listener when needed:

```java
nexmoCall.removeCallEventListener(callEventListener);
```
