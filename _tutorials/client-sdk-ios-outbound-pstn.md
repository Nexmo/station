---
title: How to Make Phone Calls with the Nexmo Client SDK on iOS
products: client-sdk
description: This tutorial shows you how to create a Nexmo Client SDK application that can place phone calls on iOS.
languages:
    - Swift
    - Objective_c
---

# How to Make Phone Calls with the Nexmo Client SDK on iOS

In this guide, you'll learn how to place a phone call from a Nexmo application to a phone device (PSTN) by implementing a webhook and linking that to a Nexmo application.

You will create a simple app to place a call. The app will automatically log in a user called `Jane`. After logging in, Jane is able to place and end a call.


## Nexmo Concepts

Before proceeding any further, here are couple of concepts that you'll need to understand.

A [Nexmo application](https://developer.nexmo.com/concepts/guides/applications) allows you to easily use Nexmo products, in this case the [Voice API](https://developer.nexmo.com/voice/voice-api/overview), to build voice applications in the Cloud.

A Nexmo application requires two URLs as parameters:

* `answer_url` - Nexmo will make a request to this URL as soon as the call is answered.
* `event_url` - Nexmo sends event information asynchronously to this URL when the call status changes; this ultimately defines the flow of the call.

Both URLs need to return JSON and follow the [Nexmo Call Control Object (NCCO)](https://developer.nexmo.com/voice/voice-api/ncco-reference) reference. In the example below, you will define an NCCO that reads a predefined text for an incoming call, using the [Text to Speech](https://developer.nexmo.com/voice/voice-api/guides/text-to-speech) engine, and then initiates the phone call.

A [Nexmo virtual number](https://developer.nexmo.com/numbers/overview) will be associated with the app and serve as the "reference point" to it - this is the number that will be the callee when you'll be testing the application.

For more information on Nexmo applications please visit the Nexmo [API Reference](https://developer.nexmo.com/api/application).


## Prerequisites

- Use an existing Nexmo Application or [create a new one](/tutorials/client-sdk-generate-test-credentials).
- Have a Nexmo phone number associated with your application or [rent one](/numbers/guides/numbers)
- Have a user named `Jane` or [create one](/tutorials/client-sdk-generate-test-credentials#create-a-user) for your Nexmo Application, with a [valid JWT](/tutorials/client-sdk-generate-test-credentials).


## Application webhook

For your application to place a phone call, you'll need to provide a URL as the `Answer URL` webhook. For the purpose of this tutorial, you will create a [gist](https://gist.github.com) with the content below:

```json
[
    {
        "action": "talk",
        "text": "Please wait while we connect you."
    },
    {
        "action": "connect",
        "timeout": 20,
        "from": "YOUR_NEXMO_NUMBER",
        "endpoint": [
            {
                "type": "phone",
                "number": "CALLEE_PHONE_NUMBER"
            }
        ]
    }
]
```

> **Do not forget to replace `YOUR_NEXMO_NUMBER` and `CALLEE_PHONE_NUMBER` with the relevant values for your app.**

Once created, add the gist raw URL (make sure you're using the raw version) to your [Nexmo dashboard](https://dashboard.nexmo.com). To do this, navigate to [applications](https://dashboard.nexmo.com/voice/your-applications), select your application and click the 'Edit' button. Set the application's `Answer URL` and click 'Save changes'.

You will need to repeat this process every time you're changing the gist as a new revision (with a different raw URL) is being created.

> The gist you created is specific to this tutorial. In a real-life scenario, the `Answer URL` should be provided by a purposely built web solution that can serve custom NCCOs and, for this case, receive and validate the phone number dialled from the app.


## The Starter Project

```tabbed_content
source: '_tutorials_tabbed_content/client-sdk/get-started/in-app-voice/outbound-pstn-ios/started-project'
```


## Login

Using the Nexmo Client SDK should start with logging in to `NexmoClient`, using a `jwt` user token.

In production apps, your server would authenticate the user, and would return a [correctly configured JWT](/client-sdk/concepts/jwt-acl) to your app.

For testing and getting started purposes, you can use the Nexmo CLI to [generate JWTs](/tutorials/client-sdk-generate-test-credentials).

```tabbed_content
source: '_tutorials_tabbed_content/client-sdk/get-started/in-app-voice/outbound-pstn-ios/login'
```

At this point you should already be able to run the app and see that you can login successfully with the SDK.


## Start a call

You can now make an App-to-Phone call.

The `Call` button press is already connected to `ViewController`.

```tabbed_content
source: '_tutorials_tabbed_content/client-sdk/get-started/in-app-voice/outbound-pstn-ios/start-call'
```

You are expected to replace `CALLEE_PHONE_NUMBER` with the number to be called but, ultimately, the number called is the one supplied in the `Answer URL` webhook. In a real-life environment, you would create a server component to server as the `Answer URL`; this will receive the `CALLEE_PHONE_NUMBER`, validate it and then supply it in the JSON returned.

**NB:** Whilst the default HTTP method for the `Answer URL` is `GET`, `POST` can also be used.


### Call Type

Note the use of `NXMCallTypeServer` as the `callType` in the `client`'s `call:` method above; this specifies that the logic of the call is defined by the server - a requirement for outbound PSTN calls.

 The other `callType` is `NXMCallTypeInApp`, useful for making simple calls as shown in [this tutorial](/tutorials/client-sdk-ios-in-app-calling).

```tabbed_content
source: '_tutorials_tabbed_content/client-sdk/get-started/in-app-voice/outbound-pstn-ios/call-type'
```


## Call Delegate

```tabbed_content
source: '_tutorials_tabbed_content/client-sdk/get-started/in-app-voice/outbound-pstn-ios/call-delegate'
```

The `statusChanged:` method notifies on changes that happens to members on the call.  


## Hangup a call

Once the "End Call" button is pressed, it is time to hangup the call. 

```tabbed_content
source: '_tutorials_tabbed_content/client-sdk/get-started/in-app-voice/outbound-pstn-ios/hangup'
```

Updates for `callMember` statuses are received in `statusChanged` as part of the `NXMCallDelegate` as you have seen before.  

The existing implementation for `statusChanged:` is already handling call hangup.


## Handle permissions

For the call to happen, `Audio Permissions` are required. In the `appDelegate` of the sample project, you can find an implementation for the permissions request in `application:didFinishLaunchingWithOptions`.  

To read more about the permissions required, [see the setup tutorial](/tutorials/client-sdk-ios-add-sdk-to-your-app#add-permissions).


## Conclusion

You have implemented your first App to Phone Voice application with the Nexmo Client SDK for iOS.

Run the app on a simulator and see that you can place and hangup a call to a PSTN phone number from the phone number associated with your Nexmo application.

If possible, test on a device using your developer signing and provisioning facility.
