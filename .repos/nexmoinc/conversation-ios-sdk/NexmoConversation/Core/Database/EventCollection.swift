//
//  EventCollection.swift
//  NexmoConversation
//
//  Created by shams ahmed on 29/03/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/// Collection of event per conversation
@objc(NXMEventCollection)
public class EventCollection: NSObject, Collection {
    
    // MARK:
    // MARK: Properties
    
    private let databaseManager: DatabaseManager
    
    private var conversationUuid: String
    private var eventCount: Int = 0
    
    /// Last event
    public var last: EventBase? {
        if eventCount > 0 {
            return self[eventCount - 1]
        }
        
        return nil
    }
    
    /// Start index
    public var startIndex: Int { return 0 }
    
    /// End index
    public var endIndex: Int { return eventCount }
    
    // MARK:
    // MARK: Initializers
    
    internal init(conversationUuid: String, databaseManager: DatabaseManager) {
        self.conversationUuid = conversationUuid
        self.databaseManager = databaseManager
        
        eventCount = databaseManager.event[in: conversationUuid].count
        
        super.init()
    }
    
    // MARK:
    // MARK: Indexing
    
    /// Get index after a position
    ///
    /// - Parameter i: index
    /// - Returns: next position
    public func index(after i: Int) -> Int {
        guard i != endIndex else { fatalError("Cannot increment beyond endIndex") }
        
        return i + 1
    }
    
    // MARK:
    // MARK: Subscript
    
    /// Get Event from position i
    ///
    /// - Parameter i: index
    public subscript(i: Int) -> EventBase {
        let eventId = databaseManager.event[at: i, in: conversationUuid]?.id
        let uuid = EventBase.uuid(from: eventId!, in: conversationUuid)
        
        return ConversationClient.instance.objectCache.eventCache.get(uuid: uuid)!
    }
}
