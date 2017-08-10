//
//  QueueObserver.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 03/04/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/// Observer for EventQueue
internal class QueueObserver: Hashable {
    
    internal var conversation: Conversation
    internal var draftMessage: EventBase?
    internal var sentMessageEventId: Int32
    internal var handlerRef: SignalReference?
    
    // MARK:
    // MARK: Initializers
    
    internal init(conversation: Conversation, draftMessage: EventBase?, sentMessageEventId: Int32, handlerRef: SignalReference?) {
        self.conversation = conversation
        self.draftMessage = draftMessage
        self.sentMessageEventId = sentMessageEventId
        self.handlerRef = handlerRef
    }
    
    // MARK:
    // MARK: Hash
    
    internal var hashValue: Int { return "\(self.conversation.uuid):\(self.sentMessageEventId)".hashValue }
}

internal func ==(lhs: QueueObserver, rhs: QueueObserver) -> Bool {
    return ((lhs.conversation == rhs.conversation) && (lhs.sentMessageEventId == rhs.sentMessageEventId))
}
