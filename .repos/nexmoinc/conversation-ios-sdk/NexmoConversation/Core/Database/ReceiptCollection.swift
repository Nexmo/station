//
//  ReceiptCollection.swift
//  NexmoConversation
//
//  Created by shams ahmed on 29/03/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/// Receipt Collection
public class ReceiptCollection: NexmoConversation.LazyCollection<ReceiptRecord> {
    
    private var event: TextEvent
    
    // MARK:
    // MARK: Initializers
    
    internal init(event: TextEvent, databaseManager: DatabaseManager) {
        self.event = event
        
        super.init()
        
        setup(with: databaseManager)
    }
    
    // MARK:
    // MARK: Private - Setup

    private func setup(with databaseManager: DatabaseManager) {
        let newUuids = databaseManager.receipt[in: event.conversation.uuid, for: event.id].map { $0.memberId }
        
        uuids.append(contentsOf: newUuids)
    }
    
    // MARK:
    // MARK: Subscript
    
    /// Get receipts for member
    ///
    /// - Parameter member: member
    public subscript(member: Member) -> ReceiptRecord? {
        let uuid = ReceiptRecord.memberAndEventToUUID(memberId: member.uuid, textEventId: event.id)
        
        return ConversationClient.instance.objectCache.receiptCache.get(uuid: uuid)
    }
    
    /// Get receipts from position i
    ///
    /// - Parameter i: i
    public override subscript(i: Int) -> ReceiptRecord {
        let uuid = ReceiptRecord.memberAndEventToUUID(memberId: uuids[i], textEventId: event.id)
        
        return ConversationClient.instance.objectCache.receiptCache.get(uuid: uuid)!
    }
}
