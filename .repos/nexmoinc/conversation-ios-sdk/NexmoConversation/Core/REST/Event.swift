//
//  Event.swift
//  NexmoConversation
//
//  Created by James Green on 06/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Gloss

/// Event model
@objc(NXMEvent)
public class Event: NSObject {
    
    // MARK:
    // MARK: Enum
    
    /// Event type
    ///
    /// - memberInvited: invited
    /// - memberJoined: joined
    /// - memberLeft: lefted
    /// - textTypingOn: is typing
    /// - textTypingOff: is not typing
    /// - eventDelete: deleted event
    /// - text: text
    /// - textDelivered: text delivered
    /// - textSeen: text seen
    /// - image: image
    /// - imageDelivered: image delivered
    /// - imageSeen: image seen
    public enum EventType: String, Equatable {
        case memberInvited = "member:invited"
        case memberJoined = "member:joined"
        case memberLeft = "member:left"
        case textTypingOn = "text:typing:on"
        case textTypingOff = "text:typing:off"
        case eventDelete = "event:delete"
        case text = "text"
        case textDelivered = "text:delivered"
        case textSeen = "text:seen"
        case image = "image"
        case imageDelivered = "image:delivered"
        case imageSeen = "image:seen"
        
        /// Compare EventType
        static public func == (lhs: EventType, rhs: EventType) -> Bool {
            switch (lhs, rhs) {
            case (.memberInvited, .memberInvited): return true
            case (.memberJoined, .memberJoined): return true
            case (.memberLeft, .memberLeft): return true
            case (.textTypingOn, .textTypingOn): return true
            case (.textTypingOff, .textTypingOff): return true
            case (.eventDelete, .eventDelete): return true
            case (.text, .text): return true
            case (.textDelivered, .textDelivered): return true
            case (.textSeen, .textSeen): return true
            case (.image, .image): return true
            case (.imageDelivered, .imageDelivered): return true
            case (.imageSeen, .imageSeen): return true
            case (.memberInvited, _),
                 (.memberJoined, _),
                 (.memberLeft, _),
                 (.textTypingOn, _),
                 (.textTypingOff, _),
                 (.eventDelete, _),
                 (.text, _),
                 (.textDelivered, _),
                 (.textSeen, _),
                 (.image, _),
                 (.imageDelivered, _),
                 (.imageSeen, _): return false
            }
        }
        
        // MARK:
        // MARK: Helper
        
        internal var toInt32: Int32 {
            switch self {
            case .memberInvited: return 1
            case .memberJoined: return 2
            case .memberLeft: return 3
            case .textTypingOn: return 4
            case .textTypingOff: return 5
            case .text: return 6
            case .eventDelete: return 7
            case .textDelivered: return 8
            case .image: return 9
            case .imageDelivered: return 10
            case .textSeen: return 11
            case .imageSeen: return 12
            }
        }
        
        internal static func fromInt32(_ from: Int32) -> EventType? {
            switch from {
            case 1: return .memberInvited
            case 2: return .memberJoined
            case 3: return .memberLeft
            case 4: return .textTypingOn
            case 5: return .textTypingOff
            case 6: return .text
            case 7: return .eventDelete
            case 8: return .textDelivered
            case 9: return .image
            case 10: return .imageDelivered
            case 11: return .textSeen
            case 12: return .imageSeen
            default: return nil
            }
        }
    }
    
    // MARK:
    // MARK: Body
    
    // Wrapper around of Event Body
    internal struct Body {
        
        // MARK:
        // MARK: Initializers
        
        private init() {
            
        }
    }
    
    // MARK:
    // MARK: Properties

    /// ID of event
    internal var id: Int32
    
    /// user who trigged the event
    internal var from: String?
    
    /// event sent to
    internal var to: String?
    
    /// body
    internal var body: JSON?
    
    /// time of event
    internal var timestamp: Date
    
    /// conversation id
    internal var cid: String
    
    // MARK:
    // MARK: Extra
    
    /// Type of event
    internal let type: EventType
    
    /// state of event 
    internal var state: EventState?
    
    // MARK:
    // MARK: Initializers

    internal init(cid: String, id: Int32, from: String?, to: String?, timestamp: Date, type: EventType) {
        self.cid = cid
        self.from = from
        self.to = to
        self.timestamp = timestamp
        self.id = id
        self.type = type
    }
    
    internal init(cid: String, type: EventType, memberId: String) {
        self.timestamp = Date()
        self.from = memberId
        self.cid = cid
        self.id = 0
        self.type = type
    }

    internal init?(conversationUuid: String?=nil, type: EventType?=nil, json: JSON) {
        self.from = "from" <~~ json
        self.to = "to" <~~ json

        // TODO: Anything that from conversation service is conversation_id, but if it goes via CAPI(socket) then it becomes cid.
        guard let cid: String = conversationUuid ?? ("cid" <~~ json ?? "conversation_id" <~~ json) else { return nil }
        self.cid = cid

        guard let body: JSON = "body" <~~ json else { return nil }
        self.body = body

        guard let formatter = DateFormatter.ISO8601,
            let timestamp: Date = Decoder.decode(dateForKey: "timestamp", dateFormatter: formatter)(json) else {
            return nil
        }
        
        self.timestamp = timestamp
        self.state = "state" <~~ json

        guard let id: Int32 = "id" <~~ json else { return nil }
        guard let type: EventType = type ?? "type" <~~ json else { return nil }
        
        self.id = id
        self.type = type
    }
    
    // MARK:
    // MARK: Body
    
    /// Unwrap body
    internal func model<T: Decodable>() -> T? {
        guard let body = body else { return nil }
        
        return T(json: body)
    }
}
