---
title: Objective-C
language: objective_c
menu_weight: 2
---

Implement `endCall` method and call hangup for `myCallMember`.

```objective-c
- (void)endCall {
    [self.loadingIndicator startAnimating];
    self.callButton.alpha = 0;
    [self.ongoingCall.myCallMember hangup];
}
```
