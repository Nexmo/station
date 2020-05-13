---
title: Java
language: java
---

```java
NexmoMemberEventListener memberEventListener = new NexmoMemberEventListener() {
    @Override
    public void onMemberInvited(@NonNull NexmoMemberEvent memberEvent) {
        Log.d("TAG", "Member " + memberEvent.member.user.name + " invited to the conversation");

        // Join user to the conversation (accept the invitation)
        conversation.join(memberEvent.getMember().getUser().getName(), joinConversationListener);
    }

    @Override
    public void onMemberAdded(@NonNull NexmoMemberEvent memberEvent) {}

    @Override
    public void onMemberRemoved(@NonNull NexmoMemberEvent memberEvent) {}
};

NexmoRequestListener<String> joinConversationListener = new NexmoRequestListener<String>() {
    @Override
    public void onSuccess(@Nullable String memberId) {
        Log.d("TAG", "Member joined the conversation " + memberId);
    }

    @Override
    public void onError(@NonNull NexmoApiError apiError) {
        Log.d("TAG", "Error: Unable to join member to the conversation " + apiError);
    }
};

conversation.addMemberEventListener(memberEventListener);
```
