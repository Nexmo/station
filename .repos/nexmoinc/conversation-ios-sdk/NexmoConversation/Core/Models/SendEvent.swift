//
//  SendEvent.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 23/12/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Alamofire

/// Payload for sending an event
internal struct SendEvent {
    
    // MARK:
    // MARK: Properties
    
    /// id of conversation
    internal let conversationId: String
    
    /// UUID of user
    internal let from: String
    
    /// type of event
    internal let type: Event.EventType
    
    /// additional payload data i.e text, image, typing model
    internal let body: Parameters
    
    // MARK:
    // MARK: Initializers
    
    /// Send a text event
    ///
    /// - parameter conversationId: id
    /// - parameter from:           from
    /// - parameter text:           text
    ///
    /// - returns: payload
    internal init(conversationId: String, from: String, text: String) {
        self.conversationId = conversationId
        self.from = from
        self.type = .text
        self.body = ["text": text]
    }
    
    /// Send a indicate status event
    ///
    /// - parameter conversationId: id
    /// - parameter from:           from
    /// - parameter text:           text
    ///
    /// - returns: payload
    internal init(conversationId: String, from: String, type: Event.EventType, eventId: Int) {
        self.conversationId = conversationId
        self.from = from
        self.type = type
        self.body = ["event_id": eventId]
    }
    
    /// Send a typing event
    ///
    /// - parameter conversationId: id
    /// - parameter from:           from
    /// - parameter isTyping:       is currently typing
    ///
    /// - returns: payload
    internal init(conversationId: String, from: String, isTyping: Bool) {
        self.conversationId = conversationId
        self.from = from
        self.type = isTyping ? .textTypingOn : .textTypingOff
        self.body = ["activity": isTyping.hashValue]
    }
    
    /// Send a image event
    ///
    /// - parameter conversationId:  id
    /// - parameter from:            from
    /// - parameter representations: image representations
    ///
    /// - returns: payload
    internal init(conversationId: String, from: String, representations: Parameters) {
        self.conversationId = conversationId
        self.from = from
        self.type = .image
        self.body = ["representations": representations]
    }
    
    /// Send any type of event
    ///
    /// - parameter conversationId: id
    /// - parameter from:           from
    /// - parameter type:           type of event
    /// - parameter body:           payload
    ///
    /// - returns: payload
    internal init(conversationId: String, from: String, type: Event.EventType, body: Parameters) {
        self.conversationId = conversationId
        self.from = from
        self.type = type
        self.body = body
    }
}
