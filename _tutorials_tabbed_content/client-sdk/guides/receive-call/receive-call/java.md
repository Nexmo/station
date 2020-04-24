---
title: Java
language: java
---

```java
NexmoIncomingCallListener incomingCallListener = new NexmoIncomingCallListener() {
    @Override
    public void onIncomingCall(NexmoCall call) {
        Log.d("TAG", "Incoming call " + call);
    }
};

val client = NexmoClient.get()
client.addIncomingCallListener(incomingCallListener);
```

Remove the listener when needed:

```java
client.removeIncomingCallListeners();
```