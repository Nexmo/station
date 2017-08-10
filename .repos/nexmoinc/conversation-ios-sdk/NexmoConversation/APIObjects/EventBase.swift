//
//  EventBase.swift
//  NexmoConversation
//
//  Created by James Green on 06/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation

/// Event Base
// TODO: remove such approach for swifty protocol oriented extensions  
@objc(NXMEventBase)
public class EventBase: NSObject {
    
    // MARK:
    // MARK: Enum
    
    /// Event Type beng sent
    ///
    /// - text: Text event
    /// - image: Image event
    /// - membership: membership event
    @objc(NXMEventType)
    public enum EventType: Int {
        case text
        case image
        case membership
    }
    
    // MARK:
    // MARK: Properties
    
    /// Database record
    internal var data: DBEvent
    
    /// Event Id
    internal var id: Int32 { return data.id }
    
    /// Event uuid
    public var uuid: String { return EventBase.uuid(from: self.data.id, in: self.data.cid) }
    
    /// Conversation linked to the event
    public var conversation: Conversation {
        /// TOOD: use DI
        return ConversationClient.instance.objectCache.conversationCache.get(uuid: data.cid)!
    }
    
    /// Creation date
    public var createDate: Date { return data.timestamp }
    
    /// Member who sent the event
    public var fromMember: Member {
        /// TOOD: use DI
        return ConversationClient.instance.objectCache.memberCache.get(uuid: data.from!)!
    }
    
    /// User who sent the event
    public var from: User { return self.fromMember.user }

    // MARK:
    // MARK: NSObject
    
    public override var description: String {
        return String(format: "(\(type(of: self)))(conversation=%@, eventId=%d)", data.cid, data.id)
    }
    
    // MARK:
    // MARK: Initializers
    
    internal init(conversationUuid: String, event: Event, seen: Bool) {
        data = DBEvent(conversationUuid: conversationUuid, event: event, seen: seen)
        
        super.init()
    }
    
    internal init(data: DBEvent) {
        self.data = data
        
        super.init()
    }
    
    internal init(conversationUuid: String, type: Event.EventType, member: Member, seen: Bool) {
        data = DBEvent(conversationUuid: conversationUuid, type: type, memberId: member.data.rest.id, seen: seen)
        
        super.init()
    }
    
    // MARK:
    // MARK: Static - Factory
    
    internal static func factory(conversationUuid: String, event: Event, seen: Bool) -> EventBase? {
        switch event.type {
        case .text: return TextEvent(conversationUuid: conversationUuid, event: event, seen: seen)
        case .image: return ImageEvent(conversationUuid: conversationUuid, event: event, seen: seen)
        default: return EventBase(conversationUuid: conversationUuid, event: event, seen: seen)
        }
    }
    
    internal static func factory(data: DBEvent) -> EventBase? {
        switch data.type {
        case .text: return TextEvent(data: data)
        case .image: return ImageEvent(data: data)
        default: return EventBase(data: data)
        }
    }
    
    // MARK:
    // MARK: Static - Helper
    
    /// Helper to go from a UUID to a conversation+event
    internal static func conversationEventId(from eventId: String) -> (/* conversation UUID */String, /* event id */Int32) {
        let components = eventId.components(separatedBy: ":")
        
        return (components[0], Int32(components[1]) ?? 0)
    }
    
    /// Helper to go from a conversation+event to a UUID
    internal static func uuid(from eventId: Int32, in uuid: String) -> String {
        return String(format: "%@:%d", uuid, eventId)
    }
}

/// Compare wherever event is the same
///
/// - Parameters:
///   - lhs: event
///   - rhs: event
/// - Returns: result
public func ==(lhs: EventBase, rhs: EventBase) -> Bool {
    return lhs.uuid == rhs.uuid
}
