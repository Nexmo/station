//
//  DBReceipt.swift
//  NexmoConversation
//
//  Created by James Green on 16/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import GRDB
import Gloss

internal class DBReceipt: Record {
    
    /// Conversation id
    internal var conversationId: String
    
    /// Member id
    internal var memberId: String
    
    // TODO: rename to eventId
    /// Event id
    internal var eventId: Int32
    
    /// Delivered date
    internal var deliveredDate: Date?
    
    /// Seen date
    internal var seenDate: Date?
    
    // MARK:
    // MARK: Initializers
    
    internal init(conversationId: String, memberId: String, eventId: Int32) {
        self.conversationId = conversationId
        self.memberId = memberId
        self.eventId = eventId
        
        super.init()
    }
    
    internal required init(row: Row) {
        conversationId = row.value(named: "cid")
        memberId = row.value(named: "member")
        eventId = row.value(named: "textEventId")
        deliveredDate = row.value(named: "deliveredDate")
        seenDate = row.value(named: "seenDate")
        
        super.init(row: row)
    }
    
    // MARK:
    // MARK: Table
    
    internal override class var databaseTableName: String {
        return "receipts"
    }
    
    // MARK:
    // MARK: Mapping
    
    internal override var persistentDictionary: [String : DatabaseValueConvertible?] {
        return ["cid": conversationId,
                "member": memberId,
                "textEventId": eventId,
                "deliveredDate": deliveredDate,
                "seenDate": seenDate
        ]
    }
}
