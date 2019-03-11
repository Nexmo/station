---
title: How to Make Phone Calls with the Nexmo Client SDK in JavaScript
products: client-sdk
description: This tutorial shows you how to use the Nexmo Client SDK in your JavaScript application in order to make phone calls.
languages:
    - JavaScript
---

# How to Make Phone Calls with the Nexmo Client SDK in JavaScript

In this guide, you'll learn how to make a phone call from a Nexmo user to phone number by implementing a webhook and linking that to a Nexmo application.

You will create a simple app to make a call. The app will automatically log in a user called jamie. After logging in, jamie is able to make a call and hang up a call.


## Nexmo Concepts

Before proceeding any further, here are couple of concepts that you'll need to understand.

A [Nexmo application](https://developer.nexmo.com/concepts/guides/applications) allows you to easily use Nexmo products, in this case the [Voice API](https://developer.nexmo.com/voice/voice-api/overview) to build voice applications in the Cloud.

A Nexmo application requires two URLs as parameters:

* `answer_url` - Nexmo will make a request to this URL as soon as you use the `callPhone` method in the SDK.
* `event_url` - Nexmo sends event information asynchronously to this URL when the call status changes; this ultimately defines the flow of the call.

Both URLs need to return JSON and follow the [Nexmo Call Control Object (NCCO)](https://developer.nexmo.com/voice/voice-api/ncco-reference) reference. In the example below, you will define an NCCO that reads a predefined text for an incoming call, using the [Text to Speech](https://developer.nexmo.com/voice/voice-api/guides/text-to-speech) engine.

A [Nexmo virtual number](https://developer.nexmo.com/numbers/overview) will be associated with the app and serve as the "entry point" to it - this is the number that will show up on call display when you make a call to test the application.

For more information on Nexmo applications please visit the Nexmo [API Reference](https://developer.nexmo.com/api/application).)


## Prerequisites

- Use an existing Nexmo Application or [create a new one](/tutorials/client-sdk-generate-test-credentials).
- Have a user named `jamie` or [create one](/tutorials/client-sdk-generate-test-credentials#create-a-user) for your Nexmo Application, with a [valid JWT](/tutorials/client-sdk-generate-test-credentials).


## Application webhook

For your application to an app user to a phone call, you'll need to provide a URL as the `Answer URL` webhook - we've created a [gist](https://gist.github.com/NexmoDev/f11d10f21fe426ddac4e30b94c6b28dc) for you to fork and update with your Nexmo phone number and personal phone number.

After you've forked and saved the gist to your account, press the "Raw" button to get a link to the raw json file. We'll need to set this as the answer URL for your Nexmo application.

To add this URL, go to your [Nexmo dashboard](https://dashboard.nexmo.com), navigate to [applications](https://dashboard.nexmo.com/voice/your-applications), select your application and click the 'Edit' button.

Now, set the application's `Answer URL` to your raw gist URL. It should look something like this:

``https://gist.githubusercontent.com/NexmoDev/f11d10f21fe426ddac4e30b94c6b28dc/raw/b14c4087097ab67503b4fdd996269502e107bce6/call-phone.json``

and click 'Save changes'.

NB: This gist is specific to this tutorial and in a real-life scenario, the `answer_url` should be provided by a purposely built web solution that can serve custom NCCO's if required.


## Adding the Nexmo Client to your application

We'll start with a blank HTML page with two buttons for calling a phone and hanging up a call. Create an `index.html` file with, and initialize it with a boilerplate, for example:

```html
<html>
  <head>
    <title>Make Phone Calls</title>
    <script src="./node_modules/nexmo-client/dist/conversationClient.js"></script>
  </head>
  <body>
    <p id="notification"></p>
    <button type="button" id="call">Call</button>
    <button type="button" id="hangup">Hang Up</button>
    <script>

    </script>
  </body>
</html>
```

We'll need to add the Nexmo Client to it, in order to do that we'll install it from NPM first, by running this command in the same folder as your `index.html` file:

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

At this point you should already be able to run the app and see that you can login successfully with the SDK. Because the Nexmo Client uses IndexedDB for it's sync mechanism, we suggest you don't serve `index.html` using the `file://` protocol. That corrupts the IndexedDB for any other users and makes the SDK behave inconsistently. You can use any HTTP server, like `http-server`:

```bash
$ npm install -g http-server
$ http-server -c-1
```


## Make a call

In order to make a call, you'll have to use the `callPhone()` method on the application object that is returned by the `login()` promise. The method accepts a string as parameter that it passes along to your `answer_url`, but since ours is a static file, we'll leave the method parameter empty.

```javascript
.then(application => {
    notification.textContent = `You've logged in with the user ${application.me.user.name}`;

    document.getElementById("call").addEventListener("click", () => {
      application.callPhone();
      notification.textContent = `You're calling a phone number`;
    })
})
```


## Listen for call events

When the application makes a call, you can start listening for `member:call` events on the application. That's going to return a `call` object, so you can start interacting with the call later on.

```javascript
.then(application => {
    notification.textContent = `You've logged in with the user ${application.me.user.name}`;
    application.on("member:call", (member, call) => {
      notification.textContent = `You're receiving a call`;
    })
})
```

The listener method receives as a parameter a `member` object that contains information about who's calling, and a `call` object, that lets you interact with the call in progress.


## Hangup a call

You can hang up a call after you've initiated it by using the `hangUp()` method on the `call` object.

```javascript
application.on("member:call", (member, call) => {
  notification.textContent = `You're receiving a call`;
  document.getElementById("hangup").addEventListener(click, () => {
    call.hangUp();
    notification.textContent = "The call has ended";
  })
})
```

## Conclusion

You have implemented your first App to Phone Voice application with the Nexmo Client SDK for JavaScript.

Open the webpage in a browser to see that you can make a call and hangup a call to a phone number. If you've followed along this tutorial, your code should look similar to [this](https://github.com/Nexmo/client-sdk-javascript-make-phone-calls/blob/master/index.html).
