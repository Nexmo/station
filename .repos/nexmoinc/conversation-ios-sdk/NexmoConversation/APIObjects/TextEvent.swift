//
//  TextEvent.swift
//  NexmoConversation
//
//  Created by James Green on 06/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation

/// Text event
@objc(NXMTextEvent)
public class TextEvent: EventBase, Deletable {
    
    // MARK:
    // MARK: Properties
    
    private var _allReceipts: ReceiptCollection?
    
    /// Text
    public private(set) var text: String? {
        // TODO: go with type-erased xD xD
        get {
            return data.text
        }
        set {
            data.text = newValue
        }
    }
    
    /// Flag to indicate event is in the process of being sent
    public var isCurrentlyBeingSent: Bool { return self.data.id >= EventQueue.draftEventOffset }
    
    /// All receipts 
    public var allReceipts: ReceiptCollection {
        guard let receipts = _allReceipts else {
            let collection = ReceiptCollection(event: self, databaseManager: ConversationClient.instance.databaseManager)
            
            _allReceipts = collection
            
            return collection
        }
        
        return receipts
    }
    
    /// List of members
    public var distribution: MemberCollection { return MemberCollection(event: self) }
    
    // MARK:
    // MARK: Properties - Observable
    
    /// Observer to listen for changes in receipts
    public let receiptRecordChanged = Signal<(event: TextEvent, receipt: ReceiptRecord)>()
    
    /// Observer to listen for new receipts
    public let newReceiptRecord = Signal<(event: TextEvent, receipt: ReceiptRecord)>()
    
    // MARK:
    // MARK: Initializers
    
    internal override init(conversationUuid: String, event: Event, seen: Bool) {
        super.init(conversationUuid: conversationUuid, event: event, seen: seen)
    }
    
    internal override init(data: DBEvent) {
        super.init(data: data)
    }
    
    internal override init(conversationUuid: String, type: Event.EventType, member: Member, seen: Bool) {
        super.init(conversationUuid: conversationUuid, type: type, member: member, seen: seen)
    }
    
    internal init(conversationUuid: String, member: Member, isDraft: Bool, distribution: [String], seen: Bool, text: String) {
        super.init(conversationUuid: conversationUuid, type: .text, member: member, seen: seen)
        
        data.isDraft = isDraft
        data.distribution = distribution
        
        self.text = text
    }
    
    // MARK:
    // MARK: State
    
    /// Mark event as seen
    ///
    /// - Returns: Result of operation
    @discardableResult
    public func markAsSeen() -> Bool {
        // TODO: remove whole method for event controller
        /* Don't send status events for our own events. */
        guard !from.isMe else { return false }
        guard !data.markedAsSeen else { return false }
        
        do {
            try ConversationClient.instance.eventQueue.add(.indicateSeen, with: self)
            
            self.data.markedAsSeen = true
            
            try ConversationClient.instance.databaseManager.event.update(data)
            
            return true
        } catch {
            return false
        }
    }
    
    // MARK:
    // MARK: Helper 
    
    /// Fetch receipt from a member
    ///
    /// - Parameter member: member
    /// - Returns: record of receipt for this event
    public func receiptForMember(member: Member) -> ReceiptRecord? {
        return allReceipts[member]
    }
    
    internal func refreshReceipts() {
        // TODO: let avoid killing object, use refresh collection
        _allReceipts = ReceiptCollection(event: self, databaseManager: ConversationClient.instance.databaseManager)
    }
}
