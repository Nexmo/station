---
title: Java
language: java
---

```java
NexmoCallEventListener callEventListener = new NexmoCallEventListener() {
   // ...
}

nexmoCall.addCallEventListener(callEventListener);
```

Remove the listener when needed:

```java
nexmoCall.removeCallEventListener(callEventListener);
```
