//
//  CRUD.swift
//  NexmoConversation
//
//  Created by shams ahmed on 29/03/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import GRDB

/// Helper for DAO object to use CRUD
internal protocol CRUD {
    
    /// Type of database model
    associatedtype T
    
    /// Database
    var database: Database { get set }
    
    // MARK:
    // MARK: CRUD
    
    /// Create table of type T
    ///
    /// - Returns: success/fail
    /// - Throws: CRUDErrors
    func createTable(in database: Database.Provider) throws
    
    /// Insert item of type T
    ///
    /// - Parameter item: item to be saved
    /// - Returns: success/fail
    /// - Throws: CRUDErrors
    func insert(_ item: T) throws
    
    /// Update item of type T
    ///
    /// - Parameter item: item to be updated
    /// - Returns: success/fail
    /// - Throws: CRUDErrors
    func update(_ item: T) throws

    /// Delete item of type T
    ///
    /// - Parameter item: item to be deleted
    /// - Returns: success/fail
    /// - Throws: CRUDErrors
    func delete(_ item: T) throws
    
    /// Delete all item of type T
    ///
    /// - Parameter item: item to be deleted
    /// - Returns: success/fail
    /// - Throws: CRUDErrors
    func deleteAll() throws
    
    // NOTE:
    // Read statement have to be done in there own implemented classes
}

extension CRUD where T: Record {
    
    // MARK:
    // MARK: Update
    
    /// Insert item of type T
    ///
    /// - Parameter item: item to be saved
    /// - Returns: success/fail
    /// - Throws: CRUDErrors
    internal func insert(_ item: T) throws {
        try database.queue.inDatabase { database in
            try item.save(database)
        }
    }
    
    /// Update item of type T
    ///
    /// - Parameter item: item to be updated
    /// - Returns: success/fail
    /// - Throws: CRUDErrors
    internal func update(_ item: T) throws {
        // GRDB check before doing insert/update
        try insert(item)
    }
    
    // MARK:
    // MARK: Delete

    /// Delete all item of type T
    ///
    /// - Parameter item: item to be deleted
    /// - Returns: success/fail
    /// - Throws: CRUDErrors
    internal func delete(_ item: T) throws {
        _ = try database.queue.inDatabase { database in
            try item.delete(database)
        }
    }
}
