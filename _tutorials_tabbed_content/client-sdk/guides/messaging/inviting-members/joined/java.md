---
title: Java
language: java
---

```java
NexmoMemberEventListener memberEventListener = new NexmoMemberEventListener() {
    @Override
    public void onMemberInvited(@NonNull NexmoMemberEvent memberEvent) {}

    @Override
    public void onMemberAdded(@NonNull NexmoMemberEvent memberEvent) {
        Log.d("TAG", "Member " + memberEvent.getMember().getUser().getName() + " added the conversation");
    }

    @Override
    public void onMemberRemoved(@NonNull NexmoMemberEvent memberEvent) {}
};

conversation.addMemberEventListener(memberEventListener);
```
