//
//  MemberDAO.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 21/04/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/// Member data access object
internal struct MemberDAO: CRUD {
    
    typealias T = DBMember
    
    internal var database: Database
    
    /// Fetch all items of type T
    ///
    /// - Returns: lists of type T
    internal var all: [T] { return database.queue.inDatabase { T.all().fetchAll($0) } }
    
    // MARK:
    // MARK: Subscript
    
    /// Fetch item by uuid
    ///
    /// - Parameter member id: member id to fetch
    /// - Returns: type T
    internal subscript(_ uuid: String) -> T? {
        return database.queue.inDatabase { T.fetchOne($0, key: uuid) }
    }
    
    /// Fetch item by parent uuid
    ///
    /// - Parameter parent: conversation parent uuid
    /// - Returns: type [T]
    internal subscript(parent uuid: String) -> [T] {
        return database.queue.inDatabase { T.all().filter(sql: "parent = ?", arguments: [uuid]).fetchAll($0) }
    }
    
    // MARK:
    // MARK: Create
    
    /// Create table of type T
    ///
    /// - Returns: success/fail
    /// - Throws: CRUD.Errors
    internal func createTable(in database: Database.Provider) throws {
        try database
            .execute("CREATE TABLE members (" +
            "memberId TEXT NOT NULL PRIMARY KEY, " +
            "parent TEXT NOT NULL, " +
            "name TEXT NOT NULL, " +
            "state INTEGER NOT NULL, " +
            "userId TEXT NOT NULL, " +
            "invitedBy TEXT NULL, " +
            "joinedTimestamp DATETIME NULL, " +
            "invitedTimestamp DATETIME NULL, " +
            "leftTimestamp DATETIME NULL" +
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
