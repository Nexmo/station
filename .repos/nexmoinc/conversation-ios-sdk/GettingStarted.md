# Using Nexmo Conversation SDK

## Session

### New session

To start a session, you need to obtain a JWT token from a service you need to build. You use the token to authenticate with the Conversation SDK.

```swift
ConversationClient.instance.login(with: JWT, { result in
    if result == .success {
        // Go to the page you want to display - possibly a list of the user's conversations
    } else {
        // Handle error
    }
})
```

## Conversation 

### New conversation

```swift
let model = CreateConversation(displayName: "Example")

client.conversationController.create(model, with: session.userId).subscribe(onNext: { member in
    // current member state    
    }, onError: { error in
    // error 
    }, onCompleted: { 
    // operation complete
    })
})
```
Note: use `with userId: String` when you like to create conversation and then join together 

### Join a conversation

```swift
client.conversation.join { (success, error) in
    if success {
        // Refresh UI
    } else {
      // Handle error
    }
}
```

### Invite a user

```swift
client.conversation.invite(user, { (user, success, error) in
    if success {
        // Refresh UI
    } else {
      // Handle error
    }
})
```

### Leave conversation

```swift
client.conversation.leave { (success, error) in
    // do something
}
```

### Get list of conversations

```swift
let conversations = client.conversationController.conversations
```

## Event

### Get a list of the conversation's events

```swift
let events: = conversation.events.value?.0
```

### Observe events from a conversation

```swift
client.conversation.events.addHandler { (events, changeType) in
    switch changeType {
    case .reset: break
    case .inserts(let indexPaths): break
    case .deletes(let indexPaths): break
    case .updates(let indexPaths): break
    case .move(let from, let to): break
    case .beginBatchEditing: break
    case .endBatchEditing: break
    }
}
```

### Send a text event

```swift
let event = conversation.createDraftEvent(.text)
event.text = "Example"

do {
    try conversation.sendEvente(event)
} catch {
    // handle error
}
```
