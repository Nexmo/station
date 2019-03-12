---
title: Objective-C
language: objective_c
menu_weight: 2
---

Clone this [Github project](https://github.com/Nexmo/Client-Get-Started-AppToPhone-Voice-ObjectiveC).

From the Github project you cloned, open the Starter app using XCode:

1. Open `IAVAppDefine.h` file and replace the user id and token:

    ```objective-c
        #define kJaneUserId @"" //TODO: swap with Jane's user id
        #define kJaneToken @"" //TODO: swap with a token for Jane
    ```

2. Open `ViewController.m` file and make sure the following lines exist:

 * `#import <NexmoClient/NexmoClient.h>` - imports the sdk
 * `@property NXMClient *nexmoClient;` - property for the client instance
 * `@property NXMCall *ongoingCall;` - property for the call instance

