---
title: JavaScript
language: javascript
---

# Getting Started with the Nexmo Conversation JS SDK

In this getting started guide we'll cover adding video events to the Conversation we created in the [simple conversation with audio](/stitch/in-app-voice/guides/1-enable-audio/javascript) getting started guide. We'll deal with video and media stream events, the ones that come via the conversation, and the ones we send to the conversation.

## Concepts

This guide will introduce you to the following concepts.

- **Video** - enabling and disabling Video streams in a Conversation
- **Media Stream Events** - `media:stream:on` events that fire on a Member in a Conversation when media streams are available.

## Before you begin

- Ensure you have run through the [previous guide](/stitch/in-app-voice/guides/1-enable-audio/javascript)

## 1 - Update the JavaScript App

We will use the application we already created for [the fourth getting started guide](/stitch/in-app-voice/guides/1-enable-audio/javascript). All the basic setup has been done in the previous guides and should be in place. We can now focus on updating the client-side application.

### 1.1 - Add video UI

First, we'll add the UI for user to enable and disable video, as well as two `<video>` elements that we'll use to play the Video streams we're sending and receiving in the conversation. Let's add the UI at the top of the messages area.

```html
<section id="messages">
  <div>
    <button id="enable-video">Enable Video</button>
    <button id="disable-video">Disable Video</button>
  </div>
  <div>
    <video id="self-video" autoplay muted></video>
    <video id="conversation-video" autoplay></video>
  </div>
  ...
</section>
```

And add the buttons and `<video>` elements in the class constructor

```javascript
constructor() {
...
  this.selfVideo = document.getElementById('self-video')
  this.conversationVideo = document.getElementById('conversation-video')
  this.enableVideoButton = document.getElementById('enable-video')
  this.disableVideoButton = document.getElementById('disable-video')
}
```

### 1.2 - Add enable and disable video handler

We'll then update the `setupUserEvents` method to trigger `conversation.media.enable({video: "both"})` when the user clicks the `Enable Video` button. We'll also add the corresponding `conversation.media.disable({video: "both"})` trigger for disabling the video stream.

```javascript
setupUserEvents() {
...
  this.enableVideoButton.addEventListener('click', () => {
    this.conversation.media.enable({
      video: "both"
    }).then(this.eventLogger('member:media')).catch(this.errorLogger)
  })
  this.disableVideoButton.addEventListener('click', () => {
    this.conversation.media.disable().then(this.eventLogger('member:media')).catch(this.errorLogger)
  })
}
```

### 1.3 - Change member:media listener

We already have a listener for `member:media` events from the conversation dealing with audio events. Now we're going to change that listener to handle video events as well and update the `messageFeed`. In order to do that, we'll change the listener for `member:media` events at the end of the `setupConversationEvents` method

```javascript
setupConversationEvents(conversation) {
  ...

  conversation.on("member:media", (member, event) => {
    console.log(`*** Member changed media state`, member, event)
    var text
    if (event.body.audio !== undefined) {
      text = `${member.user.name} <b>${event.body.audio ? 'enabled' : 'disabled'} audio in the conversation</b><br>`
    } else {
      text = `${member.user.name} <b>${event.body.video ? 'enabled' : 'disabled'} video in the conversation</b><br>`
    }
  })

}
```

If we want the conversation history to be updated accordingly, we need to update the case for `member:media` in the `showConversationHistory` switch:

```javascript
showConversationHistory(conversation) {
  ...
  switch (value.type) {
    ...
    case 'member:media':
      if (value.body.audio !== undefined) {
        eventsHistory = `${conversation.members[value.from].user.name} @ ${date}: <b>${value.body.audio ? "enabled" : "disabled"} audio</b><br>` + eventsHistory
      } else {
        eventsHistory = `${conversation.members[value.from].user.name} @ ${date}: <b>${value.body.video ? "enabled" : "disabled"} video</b><br>` + eventsHistory
      }
      break;
    ...
  }
}
```

### 1.4 - Add media:stream:on listeners

With these first parts we're listening and reacting to `member:media` events that occur in the conversation. In order to get access to the video streams, we need to listen to `media:stream:on` events as well. These events don't fire on the Conversation though, they fire on a Member. Now we're going to register a listener on `conversation.me` in order to get our own video feed. Let's add the listener at the end of the `setupConversationEvents` method

```javascript
setupConversationEvents(conversation) {
  ...

  conversation.me.on("media:stream:on", (stream) => {
    if ("srcObject" in this.selfVideo) {
      this.selfVideo.srcObject = stream.localStream;
    } else {
      // Avoid using this in new browsers, as it is going away.
      this.selfVideo.src = window.URL.createObjectURL(stream.localStream);
    }
  })

}
```

In order to get the video from the other members of the conversation, we'll have to add a listener for each Member of the Conversation. We'll add the `media:stream:on` listener on `conversation.members` at the end of the `setupConversationEvents` method:

```javascript
setupConversationEvents(conversation) {
  ...

  for (var i = Object.keys(conversation.members).length; i > 0; i--) {
    conversation.members[Object.keys(conversation.members)[i - 1]].on("media:stream:on", (stream) => {
      if ("srcObject" in this.conversationVideo) {
        this.conversationVideo.srcObject = stream.localStream;
      } else {
        // Avoid using this in new browsers, as it is going away.
        this.conversationVideo.src = window.URL.createObjectURL(stream.localStream);
      }
    })
  }
}
```

### 1.5 - Open the conversation in two browser windows

Now run `index.html` in two side-by-side browser windows, making sure to login with the user name `jamie` in one and with `alice` in the other. Enable video on both and start talking. You'll also see events being logged in the browser console.

Thats's it! Your page should now look something like [this](https://github.com/Nexmo/conversation-js-quickstart/blob/master/examples/5-enable-video/index.html).

## Where next?

- Have a look at the [Nexmo Stitch JavaScript SDK API Reference](/sdk/stitch/javascript/)
