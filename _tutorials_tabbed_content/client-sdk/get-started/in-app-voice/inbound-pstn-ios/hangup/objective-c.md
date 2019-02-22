---
title: Objective-C
language: objective_c
menu_weight: 2
---


Once Jane presses the "End Call" button, it is time to hangup the call. Implement `endCall:` method and call hangup for `myCallMember`.

```objective-c
- (IBAction)endCall:(id)sender {
    [self.ongoingCall.myCallMember hangup];
}
```

Updates for `callMember` statuses are received in `statusChanged` as part of the `NXMCallDelegate` as you have seen before.  

Update the implementation for `statusChanged` to handle call hangup:

```objective-c
- (void)statusChanged:(NXMCallMember *)callMember {
    [self updateCallStatusLabelWithStatus:callMember.status];
    
    //Handle Hangup
    if(callMember.status == NXMCallMemberStatusCancelled || callMember.status == NXMCallMemberStatusCompleted) {
        self.ongoingCall = nil;
        self.isInCall = NO;
        [self updateCallStatusLabelWithText:@"Call ended"];
        [self updateInterface];
    }
}

```