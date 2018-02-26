---
title: Overview
---

# Stitch Overview

Stitch is a conversation-centric product consisting of iOS, Android, and JavaScript SDKs and an API. Stitch enables communications across multiple channels including in-app messaging and in-app voice over IP; with PSTN voice coming soon. 

Enable chat or voice on your mobile or web application with our SDKs so that your users can seamlessly communicate no matter which device they are on.

## In-App Messaging

Build a feature rich chat experience that showcases typing indicators and sent, delivered and read receipts.

Offline Sync – With built in caching, messages are saved and sent or received once their device is back online.

Push Notifications – Keep users aware of important alerts by sending notifications to their device.

Text and Image Support – Users can quickly send and receive texts and images from your application.


## In-App Voice

Nexmo In-App Voice uses WebRTC and includes all the essentials you need to build a feature rich voice experience.

User Control – Users can control whether their audio stream is muted or unmuted. 

Notifications  – Users can be notified when they receive a call or when participants are muted. 

Group Calls – Configure call settings so users can start a group call by adding participants in real time.

## Participating in the developer preview

This Developer Preview will focus on the In-App Messaging and Voice capabilities. During this program there will be frequent releases with new features and bug fixes based on your feedback. During the preview it is possible (and probable) that there shall be breaking changes to the SDK and API but these will be explicitly communicated beforehand.

If you want communicate with us during the developer preview you can:

* Join the [Nexmo community slack](https://developer.nexmo.com/community/slack/) and ask @chris, @laka, @eric.giannini or @leggetter for access to the private [#in-app-messaging](https://nexmo-community.slack.com/messages/G5V788WHJ/) channel
* Email [ea-support@nexmo.com](mailto:ea-support@nexmo.com) directly

## Concepts

**Conversation**
    > A conversation is a shared core component that Nexmo APIs rely on. Conversations happen over multiple mediums and and can have associated Users through Memberships.

**User**
    > The concept of a user exists in Nexmo APIs, you can associate one with a user in your own application if you choose. A user can have multiple memberships to conversations and can communicate with other users through various different mediums.

**Member**
    > Memberships connect users with conversations. Each membership has one conversation and one user however a user can have many memberships to conversations just as conversations can have many members.

## Getting Started

To start with you'll need a [Nexmo Account](/account/guides/management#create-and-configure-a-nexmo-account), an [Application](/concepts/guides/applications) and the  private key provided when you created the application. Follow the prerequisites if you've not got an Application already.

| ### Prerequisites
|
| #### Install the Nexmo CLI
|
| * Ensure you have [Node.JS](https://nodejs.org/) installed
| * Create a free Nexmo account - [signup](https://dashboard.nexmo.com)
| * Install the Nexmo CLI:
|
|    ```bash
|    $ npm install -g nexmo-cli@beta
|    ```
|
|    Setup the CLI to use your Nexmo API Key and API Secret. You can get these from the [setting page](https://dashboard.nexmo.com/settings) in the Nexmo Dashboard.
|
|    ```bash
|    $ nexmo setup api_key api_secret
|    ```
|
| #### Create an Application
|
| Create an application named `My first Conversation Application` and store the returned private key as `private.key` within your current working directory.
|
| ```sh
| $ nexmo app:create "My first Conversation Application" --type=rtc --keyfile=private.key
| ```
|
|
| #### Generate a JWT
|
| With a private key you can generate a JWT with the [Nexmo CLI](/tools):
|
| ```sh
| $ nexmo jwt:generate ./private.key
| ```

### Create a Conversation

```tabbed_examples
source: _examples/conversations/overview/create-a-conversation/
```

### Create a User

```tabbed_examples
source: _examples/conversations/overview/create-a-user/
```

### Join the Conversation

```tabbed_examples
source: _examples/conversations/overview/join-the-conversation/
```

## Try out the quickstarts

* [JavaScript Quickstarts](/stitch/in-app-messaging/guides/1-simple-conversation?platform=javascript)
* [iOS Quickstarts](/stitch/in-app-messaging/guides/1-simple-conversation?platform=ios)
* [Android Quickstarts](/stitch/in-app-messaging/guides/1-simple-conversation?platform=android)

## Client Libraries

<div class="row">
  <div class="columns small-12 medium-4">
    <a href="/stitch/client-sdks/javascript" class="card spacious card--image card--javascript">
      <h2>JavaScript</h2>
    </a>
  </div>
  <div class="columns small-12 medium-4">
    <a href="/stitch/client-sdks/android" class="card spacious card--image card--android">
      <h2>Android</h2>
    </a>
  </div>
  <div class="columns small-12 medium-4">
    <a href="/stitch/client-sdks/ios" class="card spacious card--image card--ios">
      <h2>iOS</h2>
    </a>
  </div>
</div>

## Conversation API Features

* IP Messaging
* WebRTC Audio

## References

* [API Reference](/api/stitch)
* [Nexmo CLI](https://github.com/nexmo/nexmo-cli/tree/beta)
* [Server-side Gateway](https://github.com/Nexmo/messaging-gateway) with [Android](https://github.com/Nexmo/messaging-demo-android) and [JavaScript](https://github.com/Nexmo/messaging-demo-js) client demos

## API References

<div class="row">
  <div class="columns small-12 medium-4">
    <a href="/sdk/conversation/javascript/" class="card spacious card--image card--javascript-outline">
      <h2>JavaScript</h2>
    </a>
  </div>
  <div class="columns small-12 medium-4">
    <a href="/sdk/conversation/android/" class="card spacious card--image card--android-outline">
      <h2>Android</h2>
    </a>
  </div>
  <div class="columns small-12 medium-4">
    <a href="/sdk/conversation/ios/" class="card spacious card--image card--ios-outline">
      <h2>iOS</h2>
    </a>
  </div>
</div>
