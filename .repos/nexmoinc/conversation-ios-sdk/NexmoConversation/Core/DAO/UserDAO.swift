//
//  UserDAO.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 21/04/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/// User data access object
internal struct UserDAO: CRUD {
    
    typealias T = DBUser
    
    internal var database: Database
    
    /// Fetch all users
    ///
    /// - Returns: users lists
    internal var all: [T] { return database.queue.inDatabase { T.fetchAll($0) } }
    
    // MARK:
    // MARK: Subscript
    
    /// Fetch item by uuid
    ///
    /// - Parameter id: id to fetch
    /// - Returns: type T
    internal subscript(_ uuid: String) -> T? {
        return database.queue.inDatabase { T.fetchOne($0, key: uuid) }
    }
    
    // MARK:
    // MARK: Create
    
    /// Create table of type T
    ///
    /// - Returns: success/fail
    /// - Throws: CRUD.Errors
    internal func createTable(in database: Database.Provider) throws {
        try database.execute("CREATE TABLE users (" +
            "uuid TEXT NOT NULL PRIMARY KEY, " +
            "name TEXT NOT NULL, " +
            "displayName TEXT NOT NULL, " +
            "imageUrl INTEGER NOT NULL" +
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
