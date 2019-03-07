---
title: How to Receive Phone Calls with the Nexmo Client SDK in JavaScript
products: client-sdk
description: This tutorial shows you how to use the Nexmo Client SDK in your JavaScript application in order to receive phone calls.
languages:
    - JavaScript
---

# How to Receive Phone Calls with the Nexmo Client SDK in JavaScript

In this guide, you'll learn how to forward an incoming phone call from a Nexmo phone number, to an in-app user by implementing a webhook and linking that to a Nexmo application.

You will create a simple app to receive a call. The app will automatically log in a user called jamie. After logging in, jamie is able to receive a call and perform actions such as answer, decline or hangup.


## Nexmo Concepts

Before proceeding any further, here are couple of concepts that you'll need to understand.

A [Nexmo application](https://developer.nexmo.com/concepts/guides/applications) allows you to easily use Nexmo products, in this case the [Voice API](https://developer.nexmo.com/voice/voice-api/overview) to build voice applications in the Cloud.

A Nexmo application requires two URLs as parameters:

* `answer_url` - Nexmo will make a request to this URL as soon as someone makes a call to your Nexmo number.
* `event_url` - Nexmo sends event information asynchronously to this URL when the call status changes; this ultimately defines the flow of the call.

Both URLs need to return JSON and follow the [Nexmo Call Control Object (NCCO)](https://developer.nexmo.com/voice/voice-api/ncco-reference) reference. In the example below, you will define an NCCO that reads a predefined text for an incoming call, using the [Text to Speech](https://developer.nexmo.com/voice/voice-api/guides/text-to-speech) engine.

A [Nexmo virtual number](https://developer.nexmo.com/numbers/overview) will be associated with the app and serve as the "entry point" to it - this is the number you'll call to test the application.

For more information on Nexmo applications please visit the Nexmo [API Reference](https://developer.nexmo.com/api/application).)


## Prerequisites

- Use an existing Nexmo Application or [create a new one](/tutorials/client-sdk-generate-test-credentials).
- Have a user named `jamie` or [create one](/tutorials/client-sdk-generate-test-credentials#create-a-user) for your Nexmo Application, with a [valid JWT](/tutorials/client-sdk-generate-test-credentials).


## Application webhook

For your application to connect an incoming phone call to an app user, you'll need to provide a URL as the `Answer URL` webhook - we've created a [gist](https://gist.github.com/NexmoDev/6534f91245c7bc78ff83e9984c1bffb3) for you to use.

To add this URL, go to your [Nexmo dashboard](https://dashboard.nexmo.com), navigate to [applications](https://dashboard.nexmo.com/voice/your-applications), select your application and click the 'Edit' button.

Now, set the application's `Answer URL` to:

``https://gist.githubusercontent.com/NexmoDev/6534f91245c7bc78ff83e9984c1bffb3/raw/b21584a64587b09614d6bb797662eca1838621bd/call-jamie.json``

and click 'Save changes'.

NB: This gist is specific to this tutorial and in a real-life scenario, the `answer_url` should be provided by a purposely built web solution that can serve custom NCCO's if required.


## Adding the Nexmo Client to your application

We'll start with a blank HTML page with three buttons for answering, declining and hanging up a call. Create a minimal `index.html` file with:

```html
<html>
  <head>
    <title>Receive Phone Calls</title>
    <script src="./node_modules/nexmo-client/dist/conversationClient.js"></script>
  </head>
  <body>
    <p id="notification"></p>
    <button type="button" id="answer">Answer</button>
    <button type="button" id="reject">Reject</button>
    <button type="button" id="hangup">Hang Up</button>
    <script>

    </script>
  </body>
</html>
```

We'll need to add the Nexmo Client to our folder, in order to do that we'll install it from NPM first, by running this command in the same folder as your `index.html` file:

```bash
$ npm install nexmo-client --save
```

## Login

Using the Nexmo Client SDK should start with logging in to `ConversationClient`, using a `jwt` user token.

In production apps, your server would authenticate the user, and would return a [correctly configured JWT](/client-sdk/concepts/jwt-acl) to your app.

For testing and getting started purposes, you can use the Nexmo CLI to [generate JWTs](/tutorials/client-sdk-generate-test-credentials).

We'll update the empty `<script>` tag that's at the bottom of your `<body>` tag to login with a `USER_JWT`, and update the `notification` paragraph when the login was successful. We'll create a new `ConversationClient`, and then call the `login` method, with a string for the user JWT. That returns a promise containig an `application` object, and we'll use that to check we're logged in with the correct user.

```html
<script>
  const USER_JWT = "YOUR USER JWT";

  let notification = document.getElementById("notification");

  new ConversationClient()
      .login(USER_JWT)
      .then(application => {
          notification.textContent = `You've logged in with the user ${application.me.user.name}`
      })
      .catch(console.log);
</script>
```

At this point you should already be able to run the app and see that you can login successfully with the SDK. Because the Nexmo Client uses IndexedDB for it's sync mechanism, we suggest you don't serve `index.html` using the `file://` protocol. That corrupts the IndexedDB for any other users and makes the SDK behave inconsistently. You can use any HTTP server, like `http-server`. If you want to install it from NPM and then run it with cache disabled, here are the terminal commands:

```bash
$ npm install -g http-server
$ http-server -c-1
```


## Listen for incoming call

When the phone number associated with your Nexmo app receives a call, the application should notify the user `jamie` so that they can decide whether to answer or reject it.

This is done by listening for `member:call` events on the `application` object returned by the `login()` promise.

```javascript
.then(application => {
    notification.textContent = `You've logged in with the user ${application.me.user.name}`;
    application.on("member:call", (member, call) => {
      notification.textContent = `You're receiving a call`;
    })
})
```

The listener method takes as a parameter an `member` object that contains information about who's calling, and a `call` object, that lets you interact with the call in progress.


## Answer a call

In order to answer a call, you'll have to use the `answer()` method on the call object that you received when the `member:call` event was triggered.

```javascript
application.on("member:call", (member, call) => {
  notification.textContent = `You're receiving a call`;

  document.getElementById("answer").addEventListener("click", () => {
    call.answer();
    notification.textContent = `You're in a call`;
  })
})
```


## Reject a call

In order to reject an incoming call, you'll have to use the `reject()` method on the call object that you received when the `member:call` event was triggered.

```javascript
application.on("member:call", (member, call) => {
  notification.textContent = `You're receiving a call`;
  ...
  document.getElementById("reject").addEventListener("click", () => {
    call.reject();
    notification.textContent = `You rejected the call`;
  })
})
```

## Hangup a call

You can hang up a call after you've answered it by using the `hangUp()` method on the `call` object.

```javascript
application.on("member:call", (member, call) => {
  notification.textContent = `You're receiving a call`;
  ...
  document.getElementById("hangup").addEventListener("click", () => {
    call.hangUp();
    notification.textContent = "The call has ended";
  })
})
```

## Conclusion

You have implemented your first Phone to App Voice application with the Nexmo Client SDK for JavaScript.

Open the webpage in a browser to see that you can answer, reject and hangup a call received on the phone number associated with your Nexmo application. If you've followed along this tutorial, your code should look similar to [this](https://github.com/Nexmo/client-sdk-javascript-receive-phone-calls/blob/master/index.html).
