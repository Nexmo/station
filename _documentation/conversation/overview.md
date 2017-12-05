---
title: Overview
---

# In-App Messaging Overview

Nexmo In-App Messaging enables you to build conversation features where communication can take place across multiple platforms.

The context of the conversations is maintained though each communication event taking place within a conversation, no matter the medium.

> ### In-App Messaging is in developer preview
>
> Currently In-App Messaging offers basic IP messaging with the following features:
>
> * Conversation creation and management
> * Sending and receiving text
> * Member invite management
> * Cache support
> * Typing indicators
> * Message sent, delivered and read receipts
> * Image support
> * Push notifications

## Participating in the developer preview

This Developer Preview will focus on the IP messaging capabilities. During this program there will be frequent releases with new features and bug fixes based on your feedback. During the preview it is possible (and probable) that there shall be breaking changes to the SDK and API but these will be explicitly communicated beforehand.

> #### If you are interested in access to the Conversation Developer Preview§§
> #### Email: [ea-support@nexmo.com](mailto:ea-support@nexmo.com).

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

* [JavaScript Quickstarts](/conversation/guides/javascript-quickstart)
* [iOS Quickstarts](/conversation/guides/ios-quickstart)
* [Android Quickstarts](/conversation/guides/android-quickstart)

## Client Libraries

<div class="row">
  <div class="columns small-12 medium-4">
    <a href="/conversation/client-sdks/javascript" class="card spacious card--image card--javascript">
      <h2>JavaScript</h2>
    </a>
  </div>
  <div class="columns small-12 medium-4">
    <a href="/conversation/client-sdks/android" class="card spacious card--image card--android">
      <h2>Android</h2>
    </a>
  </div>
  <div class="columns small-12 medium-4">
    <a href="/conversation/client-sdks/ios" class="card spacious card--image card--ios">
      <h2>iOS</h2>
    </a>
  </div>
</div>

## Conversation API Features

* IP Messaging
* WebRTC Audio [Coming soon]

## References

* [API Reference](/api/conversation)
* [Nexmo CLI](https://github.com/nexmo/nexmo-cli/tree/beta)

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
