---
title: Objective-C
language: objective_c
menu_weight: 2
---

Clone this [Github project](https://github.com/Nexmo/Client-Get-Started-PhoneToApp-Voice-ObjectiveC).

From the Github project you cloned, open the Starter app using XCode:

1. Open `IAVAppDefine.h` file and replace the user token:

    ```objective-c
        #define kInAppVoiceJaneToken @"JANE_TOKEN" //TODO: replace with a token for Jane
    ```

2. Open `MainViewController.m` file and make sure the following lines exist:

 * `#import <NexmoClient/NexmoClient.h>` - imports the sdk
 * `@property NXMClient *nexmoClient;` - property for the client instance
 * `@property NXMCall *ongoingCall;` - property for the call instance

