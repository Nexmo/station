//
//  CacheManager.swift
//  NexmoConversation
//
//  Created by James Green on 31/08/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation

/// TODO: make sure only this class and DatabaseController has access to the db
/// TODO: rename to Storage
internal class CacheManager {
    
    internal let conversationCache = ObjectCache<Conversation>()
    internal let memberCache = ObjectCache<Member>()
    internal let userCache = ObjectCache<User>()
    internal let eventCache = ObjectCache<EventBase>()
    internal let receiptCache = ObjectCache<ReceiptRecord>()
    internal let database: DatabaseManager
    
    internal weak var eventQueue: EventQueue?
    
    private let eventController: EventController
    private let account: AccountController
    private let conversation: ConversationController
    private let membershipController: MembershipController

    // MARK:
    // MARK: Initializers
    
    internal init(databaseManager: DatabaseManager,
                  eventController: EventController,
                  account: AccountController,
                  conversation: ConversationController,
                  membershipController: MembershipController) {
        database = databaseManager
        self.eventController = eventController
        self.account = account
        self.conversation = conversation
        self.membershipController = membershipController
        
        setup()
    }
    
    // MARK:
    // MARK: Setup
    
    private func setup() {
        conversationCache.setGenerator { [unowned self](/* uuid */uuid) in
            if Environment.inDebug, self.eventQueue == nil {
                assertionFailure("Task queue should not be nil")
            }
            
            guard let conversation = self.database.conversation[uuid] else { return nil }
            guard let eventQueue = self.eventQueue else { return nil }
            
            return Conversation(conversation,
                                   eventController: self.eventController,
                                   databaseManager: self.database,
                                   eventQueue: eventQueue,
                                   account: self.account,
                                   conversationController: self.conversation,
                                   membershipController: self.membershipController
            )
        }
        
        memberCache.setGenerator { [unowned self](/* uuid */uuid) in
            guard let member = self.database.member[uuid] else { return nil }
            
            return Member(data: member)
        }
        
        userCache.setGenerator { [unowned self](/* uuid */uuid) in
            guard let user = self.database.user[uuid] else { return nil }
            
            return User(data: user)
        }
        
        eventCache.setGenerator { [unowned self](/* uuid */uuid) in
            let (conversationUuid, eventId) = EventBase.conversationEventId(from: uuid)
            
            guard let event = self.database.event[with :eventId, in: conversationUuid] else { return nil }
            
            return EventBase.factory(data: event)
        }
        
        receiptCache.setGenerator { [unowned self](/* uuid */uuid) in
            let (memberId, eventId) = ReceiptRecord.UUIDtoMemberAndEvent(receiptUuid: uuid)
            
            guard let receipt = self.database.receipt[memberId, for: eventId] else { return nil }
                
            return ReceiptRecord(data: receipt)
        }
    }

    // MARK:
    // MARK: Cleaning

    /// Clears all caches.
    internal func clear() {
        conversationCache.clear()
        memberCache.clear()
        userCache.clear()
        eventCache.clear()
        receiptCache.clear()
    }
}
