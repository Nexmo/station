//
//  DBTask.swift
//  NexmoConversation
//
//  Created by James Green on 13/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import GRDB

/// Task
internal class DBTask: Record {
    
    /// Operation type
    ///
    /// - send: send event
    /// - indicateDelivered: send delivered
    /// - indicateSeen: send seen
    /// - delete: send delete
    internal enum OperationType: Int32 {
        case send
        case indicateDelivered
        case indicateSeen
        case delete
    }
    
    /// Task Uuid
    internal var uuid: Int64?
    
    /// Task being processing in queue
    internal var beingProcessed: Bool
    
    /// Task type
    internal var type: OperationType
    
    /// Related to Event
    internal var related: String?
    
    /// Retry count
    internal var retryCount: Int
    
    // MARK:
    // MARK: Initializers

    internal required init(row: Row) {
        uuid = row.value(named: "uuid") as Int64
        beingProcessed = row.value(named: "beingProcessed")
        type = OperationType(rawValue: row.value(named: "type"))!
        related = row.value(named: "related")        
        retryCount = row.value(named: "retryCount")
        
        super.init(row: row)
    }
    
    internal init(_ type: OperationType) {
        beingProcessed = false
        self.type = type
        retryCount = 0
        
        super.init()
    }
    
    // MARK:
    // MARK: Observer

    override func didInsert(with rowID: Int64, for column: String?) {
        /* Pick up our auto-incrementing primary key. */
        if column == "uuid" {
            uuid = rowID
        }
    }
    
    // MARK:
    // MARK: Table
    
    override class var databaseTableName: String {
        return "tasks"
    }
    
    override var persistentDictionary: [String : DatabaseValueConvertible?] {
        return ["uuid": uuid,
                "beingProcessed": beingProcessed,
                "type": type.rawValue,
                "related": related,
                "retryCount": retryCount
        ]
    }
}
