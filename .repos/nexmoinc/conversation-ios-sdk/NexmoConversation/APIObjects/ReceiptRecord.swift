//
//  ReceiptRecord.swift
//  NexmoConversation
//
//  Created by James Green on 12/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation

/// Receipt Record
@objc(NXMReceiptRecord)
public class ReceiptRecord: NSObject {
    
    // MARK:
    // MARK: Enum
    
    // TODO: rename to State
    /// Receipt State
    ///
    /// - sending: event is being sent
    /// - delivered: event has been delivered
    /// - seen: event has been seen
    @objc(NXMReceiptState)
    public enum ReceiptState: Int, Equatable {
        case sending
        case delivered
        case seen
        
        /// Compare ReceiptState
        static public func == (lhs: ReceiptState, rhs: ReceiptState) -> Bool {
            switch (lhs, rhs) {
            case (.sending, .sending): return true
            case (.delivered, .delivered): return true
            case (.seen, .seen): return true
            case (.sending, _),
                 (.delivered, _),
                 (.seen, _): return false
            }
        }
    }
    
    // MARK:
    // MARK: Properties
    
    internal var data: DBReceipt
    
    /// Event
    public var event: EventBase {
        let uuid = EventBase.uuid(from: data.eventId, in: member.conversation.uuid)
        let event = ConversationClient.instance.objectCache.eventCache.get(uuid: uuid)
        
        return event!
    }
    
    /// Event state
    public var state: ReceiptState {
        if data.seenDate != nil {
            return .seen
        } else if data.deliveredDate != nil {
            return .delivered
        } else {
            return .sending
        }
    }
    
    /// List of members
    public var member: Member { return ConversationClient.instance.objectCache.memberCache.get(uuid: data.memberId)! }
    
    /// Date of receipt
    public internal(set) var date: Date? {
        get {
            if state == .seen {
                return data.seenDate
            } else if state == .delivered {
                return data.deliveredDate
            }
            
            return nil
        }
        set {
            if state == .seen {
                data.seenDate = newValue
            } else if state == .delivered {
                data.deliveredDate = newValue
            }
        }
    }
    
    // MARK:
    // MARK: Initializers
    
    internal init(data: DBReceipt) {
        self.data = data

        super.init()
    }
    
    // MARK:
    // MARK: Static - Helper
    
    internal static func UUIDtoMemberAndEvent(receiptUuid: String) -> (String, Int32) {
        let components = receiptUuid.components(separatedBy: ":")
        
        return (components[0], Int32(components[1]) ?? 0)
    }
    
    internal static func memberAndEventToUUID(memberId: String, textEventId: Int32) -> String {
        return String(format: "%@:%d", memberId, textEventId)
    }
}
