---
title: Objective-C
language: objective_c
menu_weight: 2
---


As with `NXMClient`, `NXMCall` also has a delegate. Add the required protocol adoption declaration to the class extension located in the `MainViewController.m` file:

```objective-c
@interface MainViewController () <NXMClientDelegate, NXMCallDelegate>
```

Copy the following implementation for the `statusChanged` method of the `NXMCallDelegate` along with the aid methods under the `#pragma mark NXMCallDelegate` line:

```objective-c
- (void)statusChanged:(NXMCallMember *)callMember {
    [self updateCallStatusLabelWithStatus:callMember.status];
}
```