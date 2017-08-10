//
//  ReceiptDAO.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 21/04/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/// Receipt data access object
internal struct ReceiptDAO: CRUD {
    
    typealias T = DBReceipt
    
    internal var database: Database
    
    // MARK:
    // MARK: Subscript
    
    /// Fetch receipt in event id for a member
    ///
    /// - Parameters:
    ///   - memberId: member id
    ///   - eventId: for event
    internal subscript(_ memberId: String, for eventId: Int32) -> T? {
        return database.queue.inDatabase { T.fetchOne($0, key: ["member": memberId, "textEventId": eventId]) }
    }
    
    /// Fetch receipt in event id from a given conversation id
    ///
    /// - Parameters:
    ///   - memberId: member id
    ///   - eventId: for event
    internal subscript(in uuid: String, for eventId: Int32) -> [T] {
        return database.queue.inDatabase {
            T.all()
            .filter(sql: "textEventId = '\(eventId)' AND cid = '\(uuid)'")
            .fetchAll($0)
        }
    }
    
    /// Fetch all items of type T in conversation uuid
    ///
    /// - Parameter uuid: conversation uuid
    /// - Returns: lists of type T
    internal subscript(in uuid: String) -> [T] {
        return database.queue.inDatabase { T.all().filter(sql: "cid = '\(uuid)'").fetchAll($0) }
    }
    
    /// Fetch item by memberId
    ///
    /// - Parameter for: member id to fetch
    /// - Returns: type T
    internal subscript(_ memberId: String) -> [T] {
        return database.queue.inDatabase { T.all().filter(sql: "member = '\(memberId)'").fetchAll($0) }
    }
    
    // MARK:
    // MARK: Create
    
    /// Create table of type T
    ///
    /// - Returns: success/fail
    /// - Throws: CRUD.Errors
    internal func createTable(in database: Database.Provider) throws {
        try database.execute("CREATE TABLE receipts (" +
            "cid TEXT NOT NULL, " +
            "member TEXT NOT NULL, " +
            "textEventId INTEGER NOT NULL, " +
            "deliveredDate DATETIME, " +
            "seenDate DATETIME, " +
            "PRIMARY KEY (member, textEventId)" +
            ")"
        )
    }
    
    // MARK:
    // MARK: Delete
    
    /// Delete all item of type T
    ///
    /// - Parameter item: item to be deleted
    /// - Returns: success/fail
    /// - Throws: CRUDErrors
    internal func deleteAll() throws {
        _ = try database.queue.inDatabase { try T.deleteAll($0) }
    }
}
