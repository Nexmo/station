//
//  TaskDAO.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 03/04/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/// Event data access object
internal struct TaskDAO: CRUD {
    
    typealias T = DBTask
    
    internal var database: Database
    
    /// All task that are pending and haven't had max retry count reached yet
    internal var pending: [T] {
        return database.queue.inDatabase {
            T.all()
                .filter(sql: "beingProcessed = 0 AND retryCount < \(EventQueue.maximumRetries)")
                .fetchAll($0)
        }
    }
    
    /// All task that are active
    internal var active: [T] {
        return database.queue.inDatabase {
            T.all()
                .filter(sql: "beingProcessed = 1")
                .fetchAll($0)
        }
    }
    
    // MARK:
    // MARK: Subscript
    
    /// Fetch all from a type where its not been procssed yet and haven't had max retry count reached yet
    ///
    /// - Parameter type: operation type
    /// - Returns: list of task matching type
    internal subscript(type: T.OperationType) -> [T] {
        return database.queue.inDatabase {
            T.all()
                .filter(sql: "type = ? AND beingProcessed = 0 AND retryCount < ?",
                        arguments: [type.rawValue, EventQueue.maximumRetries])
                .order(sql: "uuid ASC")
                .fetch($0)
                .map { $0 }
        }
    }
    
    // MARK:
    // MARK: Create
    
    /// Create table of type T
    ///
    /// - Returns: success/fail
    /// - Throws: CRUD.Errors
    internal func createTable(in database: Database.Provider) throws {
        try database.execute("CREATE TABLE tasks (" +
            "uuid INTEGER PRIMARY KEY AUTOINCREMENT, " +
            "beingProcessed BOOLEAN NOT NULL, " +
            "type INTEGER NOT NULL, " +
            "retryCount INTEGER NOT NULL, " +
            "related TEXT" +
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
    
    // MARK:
    // MARK: Helper
    
    /// Clear task queue
    ///
    /// - Throws: CRUDErrors
    internal func clear() throws {
        try database.queue.inDatabase { try $0.execute("UPDATE tasks SET beingProcessed = 0, retryCount = 0") }
    }
}
