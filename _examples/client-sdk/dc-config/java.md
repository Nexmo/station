---
title: Java
language: java
---

``` java
NexmoClient nexmoClient = new NexmoClient.Builder()
    .restEnvironmentHost("https://api-eu-1.nexmo.com")
    .environmentHost("https://ws-eu-1.nexmo.com")
    .imageProcessingServiceUrl("https://api-eu-1.nexmo.com/v1/image")
    .build(this);
```