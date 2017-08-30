---
title: Overview
---

# Conversation Overview

The Nexmo Conversation API enables you to build conversation features where communication can take place across multiple mediums including Messaging, Voice, Video & SMS.

The context of the conversations is maintained though each communication event taking place within a conversation, no matter the medium.

> ### The Conversation API is in [developer preview](/conversation/developer-preview)
>
> Currently the Conversation API offers basic IP messaging with the following features:
>
> * Conversation creation and management
> * Sending and receiving text
> * Member invite management
> * Cache support
> * Typing indicators
> * Message sent, delivered and read receipts
>
> Upcoming features will include:
>
> * Image support
> * Push notifications
> * Voice support

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

* [IP Messaging](/conversation/guides/ip-messaging)
* PSTN Voice [Coming soon]
* WebRTC Audio [Coming soon]
* WebRTC Video [Coming soon]

## References

* [API Reference](/api/conversation)

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
