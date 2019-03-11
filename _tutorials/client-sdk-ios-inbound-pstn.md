---
title: How to Receive Phone Calls with the Nexmo Client SDK on iOS
products: client-sdk
description: This tutorial shows you how to create a Nexmo Client SDK application that can receive phone calls on iOS.
languages:
    - Objective_c
    - Swift
---


# How to Receive Phone Calls with the Nexmo Client SDK on iOS

In this guide, you'll learn how to receive an incoming phone call in a iOS application. 

You will create a simple iOS app, that will automatically log in a user called Jane. After logging in, Jane is able to receive a call and perform actions such as answer, reject or hangup.


## Nexmo Concepts

Before proceeding any further, here are a couple of concepts that you'll need to understand.

A [Nexmo application](/concepts/guides/applications) allows you to easily use Nexmo products, in this case the [Voice API](/voice/voice-api/overview) to build voice applications in the Cloud.

A Nexmo application requires two URLs as parameters:

* `answer_url` - Nexmo will make a request to this URL as soon as the call is answered.
* `event_url` - Nexmo sends event information asynchronously to this URL when the call status changes; this ultimately defines the flow of the call.

Both URLs need to return a JSON and follow the [Nexmo Call Control Object (NCCO)](/voice/voice-api/ncco-reference) reference. In the example below, you will define an NCCO that reads a predefined text for an incoming call, using the [Text to Speech](/voice-api/guides/text-to-speech) engine.

A [Nexmo virtual number](/numbers/overview) will be associated with the app and serve as the "entry point" to it - this is the number you'll call to test the application.

For more information on Nexmo applications please visit the Nexmo [API Reference](/api/application).)


## Prerequisites

- Use an existing Nexmo Application or [create a new one](/tutorials/client-sdk-generate-test-credentials).
- Have a user named `Jane` or [create one](/tutorials/client-sdk-generate-test-credentials#create-a-user) for your Nexmo Application, with a [valid JWT](/tutorials/client-sdk-generate-test-credentials).


## Application webhook

For your application to connect an incoming phone call to an app user, you'll need to provide a URL as the [`Answer URL` webhook](/voice/voice-api/webhook-reference#answer-webhook). In other words, this response from this `answer_url` defines the fllow of the call. For this tutorial, a [gist](https://gist.github.com/NexmoDev/ed91ac99a0b278fbdcbde72ca3599ac7) was created for you to use.

To add this URL: 
* Go to your [Nexmo dashboard](https://dashboard.nexmo.com)
* Navigate to [applications](https://dashboard.nexmo.com/voice/your-applications)
* Select your application
* Click the 'Edit' button.

* Now, set the application's `Answer URL` to: 

`https://gist.githubusercontent.com/NexmoDev/ed91ac99a0b278fbdcbde72ca3599ac7/raw/da2b2853ebd1798404fa040942eedab1d03fdac3/ncco.json`

* Click 'Save changes'.

> **NOTE**: This gist is *specific* to this tutorial. In a real-life scenario, the `answer_url` should be provided by your backend, as a purposely built web solution that can serve custom NCCOs as your app's use case requires.


## Link a Nexmo Virtual Number

A Nexmo virtual number [Nexmo phone number](/numbers/guides/numbers) is a phone number that you can link to your Nexmo Application. When a user calls that phone number, the `answer_url` that is defined on your Nexmo Application is executed. In this tutorial case, you set up an `answer_url` in the above step, that upon calling connects the call to your app user `Jane`.

To link a Nexmo number to your app:

* Go to your [Nexmo dashboard](https://dashboard.nexmo.com)
* Navigate to [applications](https://dashboard.nexmo.com/voice/your-applications)
* Select your application
* Click the 'Edit' button.

* Switch to `Numbers` tab above, search for a number you'd like, and click `Link`, to link.

## The starter project

```tabbed_content
source: '_tutorials_tabbed_content/client-sdk/get-started/in-app-voice/inbound-pstn-ios/started-project'
```

## Login

Using the Nexmo Client SDK should start with logging in to `NexmoClient`, using a `jwt` user token.

In production apps, your server would authenticate the user, and would return a [correctly configured JWT](/client-sdk/concepts/jwt-acl) to your app.

For testing and getting started purposes, you can use the Nexmo CLI to [generate JWTs](/tutorials/client-sdk-generate-test-credentials).

```tabbed_content
source: '_tutorials_tabbed_content/client-sdk/get-started/in-app-voice/inbound-pstn-ios/login'
```

At this point you should already be able to run the app and see that you can login successfully with the SDK.


## Receive incoming call

When the phone number associated with your Nexmo app receives a call, the app should notify the user `Jane` so that she can decide whether to answer or reject it.

This is done by implementing the optional `incomingCall:` method which is declared in the `NXMClientDelegate`.

```tabbed_content
source: '_tutorials_tabbed_content/client-sdk/get-started/in-app-voice/inbound-pstn-ios/receive'
```

This method takes as a parameter an `NXMCall` object with which you can answer or reject the call. An alert was implemented for you, to allow the user to choose whether to answer or reject the call.


## Answer a call

```tabbed_content
source: '_tutorials_tabbed_content/client-sdk/get-started/in-app-voice/inbound-pstn-ios/answer'
```

`answer:completionHandler:` accepts an object adopting the `NXMCallDelegate` and a completion block to indicate if an error occurred in the process. You already implemented `NXMCallDelegate` in a previous step.


## Reject a call

```tabbed_content
source: '_tutorials_tabbed_content/client-sdk/get-started/in-app-voice/inbound-pstn-ios/answer'
```

`reject:` accepts a single `completionHandler` parameter to indicate if an error occurred in the process.


## Call Delegate

```tabbed_content
source: '_tutorials_tabbed_content/client-sdk/get-started/in-app-voice/inbound-pstn-ios/call-delegate'
```

The `statusChanged:` method notifies on changes that happens to members on the call.  


## Hangup a call

```tabbed_content
source: '_tutorials_tabbed_content/client-sdk/get-started/in-app-voice/inbound-pstn-ios/hangup'
```


## Handle permissions

For the call to happen, `Audio Permissions` are required. In the `appDelegate` of the sample project, you can find an implementation for the permissions request in `application:didFinishLaunchingWithOptions`.  

To read more about the permissions required, [see the setup tutorial](/tutorials/client-sdk-ios-add-sdk-to-your-app#add-permissions).


## Conclusion

Congratulations! You have implemented your first Phone to App Voice application with the Nexmo Client SDK for iOS.

Run the app on a simulator, and with another device call the nexmo Number you linked. Then, see that you can answer, reject and hangup a call received on the phone number associated with your Nexmo application.

If possible, test the application on a device using your developer signing and provisioning facility.

