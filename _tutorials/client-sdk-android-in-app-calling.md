---
title: How to Make and Receive Voice calls with the Nexmo Client SDK on Android
products: client-sdk
description: This tutorial shows you how to create a Nexmo Client SDK application that can make and receive voice calls on Android.
languages:
    - Java
    - Kotlin
---

# How to Make and Receive Voice calls with the Nexmo Client SDK on Android

In this tutorial you learn how to use the Nexmo Client SDK for Android, in order to perform an in-app (IP to IP) voice call.

You create a simple app that can make a call and receive a call.

The app will have two buttons, which log in different users: Jane or Joe. After logging in, Jane and Joe are able to place a call and perform actions such as answer, reject or hangup.

## Prerequisites

1. [Create a Nexmo Application](/tutorials/client-sdk-generate-test-credentials).

2. [Create two users](/tutorials/client-sdk-generate-test-credentials) on that Nexmo Application: one with the name `Jane` and the other with the name `Joe`.

3. Clone or download the GitHub repository on either [Java](https://github.com/Nexmo/Client-Get-Started-InApp-Voice-Android-Java) or [Kotlin](https://github.com/Nexmo/Client-Get-Started-InApp-Voice-Android-Kotlin). On that repository you'll find two apps:

- `GetStartedCalls-Start` - if you want to follow along and add the code with this tutorials
- `GetStartedCalls-Complete` - if you want to look at the final result

Open the `NexmoHelper` class and replace the users ID and tokens:

```tabbed_content
source: '_examples/client-sdk/tutorials/voice/in-app-to-in-app/user-keys'
frameless: false
```

## Login

To start using the Nexmo Client SDK you need to log in to `NexmoClient`, using a JWT user token.

In production apps, your server would authenticate the user, and would return a [correctly configured JWT](/client-sdk/concepts/jwt-acl) to your app.

For testing and getting started purposes, you can use the Nexmo CLI to [generate JWTs](/tutorials/client-sdk-generate-test-credentials).

Open `LoginActivity`. It already has two button handlers:`onLoginJaneClick(...)` and `onLoginJoeClick(...)`. Each calls the `loginToSdk(...)` method, with a different parameter - the corresponding `jwt`. When the login is successful, the logged in `NexmoUser` returns. For convenience, save a reference to `NexmoUser` on `NexmoHelper`, and then, start `CreateCallActivity`.

Complete the `loginToSdk()` method implementation:

```tabbed_content
source: '_examples/client-sdk/tutorials/voice/in-app-to-in-app/login'
frameless: false
```

## Start a Call

You can now make a simple In-App call. If you logged in as Jane, you can call Joe, and if you logged in as Joe you can call Jane.

Open `CreateCallActivity` and complete the prepared `onInAppCallClick()` handler:

```tabbed_content
source: '_examples/client-sdk/tutorials/voice/in-app-to-in-app/click-call'
frameless: false
```

When the call creation is successful, save the `NexmoCall` on `NexmoHelper`, for convenience, and start `OnCallActivity`:

```tabbed_content
source: '_examples/client-sdk/tutorials/voice/in-app-to-in-app/start-call-activity'
frameless: false
```

You can also start a call with customized logic [using an NCCO](/client-sdk/in-app-voice/concepts/ncco-guide), by choosing `NexmoCallHandler.SERVER` as the `CallHandler`:

```tabbed_content
source: '_examples/client-sdk/tutorials/voice/in-app-to-in-app/call-handler-server'
frameless: false
```

This allows you to start a PSTN phone call, by adding a phone number to the `callees` list.

## Register for incoming events

When Jane calls Joe, Joe should be notified. Joe can then answer the call. Joe should register for incoming events, and implement `onIncomingCall()`. Whenever Joe is called, `onIncomingCall()` is invoked with the incoming Call object.

For simplicity in this example, you will accept incoming calls only on `CreateCallActivity`. Open `CreateCallActivity` and create the `NexmoIncomingCallListener` to save the reference to the incoming call on `NexmoHelper`, and start `IncomingCallActivity`:

```tabbed_content
source: '_examples/client-sdk/tutorials/voice/in-app-to-in-app/start-incoming-call-activity'
frameless: false
```

You need to register and unregister the listener in `onCreate()` and `onDestroy()`:

```tabbed_content
source: '_examples/client-sdk/tutorials/voice/in-app-to-in-app/register-incoming-events'
frameless: false
```

## Answer a call

Once Joe receives the incoming call it can be answered. Open `IncomingCallActivity`, and complete the prepared `onAnswer()` button handler, to start `OnCallActivity` after a successful answer:

```tabbed_content
source: '_examples/client-sdk/tutorials/voice/in-app-to-in-app/on-answer'
frameless: false
```

## Hangup

The `onHangup()` handler allows Joe to reject the call. Complete the implementation in `IncomingCallActivity` to finish the activity:

```tabbed_content
source: '_examples/client-sdk/tutorials/voice/in-app-to-in-app/on-hangup'
frameless: false
```

## Register to call status

If Joe hangs up the call, Jane should be notified, and finish `OnCallActivity`. The same way, if Jane decides to hangup before Joe answers, Joe should be notified and finish `IncomingCallActivity`.

To be notified on the different call statuses, you should register to `CallEvents`. The `FinishOnCallEnd` is a simple `NexmoCallEventListener` that finishes the current activity if the call is completed or canceled.

Register to its instance, to address the use cases mentioned previously.

On both `OnCallActivity` and `IncomingCallActivity`, add:

```tabbed_content
source: '_examples/client-sdk/tutorials/voice/in-app-to-in-app/finish-call-listener'
frameless: false
```

## Handle permissions

For devices running Android 6.0 (API level 23) and higher, creation and operation of calls requires requesting runtime permissions. To simplify the implementation in this tutorial, `BaseActivity` checks the permissions in every Activity's `onStart()` and `onStop()`.

To read more about the permissions required, [see the setup tutorial](/tutorials/client-sdk-android-add-sdk-to-your-app#add-permissions).

# Conclusion

You have implemented your first In-App Voice application with Nexmo Client SDK for Android.

You can now run the app on two devices, log in as two different users, and start an in-app voice call between the users.
