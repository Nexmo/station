//
//  EventDAO.swift
//  NexmoConversation
//
//  Created by shams ahmed on 29/03/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/// Event data access object
internal struct EventDAO: CRUD {
    
    typealias T = DBEvent
    
    internal var database: Database
    
    // MARK:
    // MARK: Subscript
    
    /// Fetch all items of type T
    ///
    /// - Returns: lists of type T
    internal subscript(in uuid: String) -> [T] {
        return database.queue.inDatabase { T.all().filter(sql: "cid = '\(uuid)'").fetchAll($0) }
    }
    
    /// Fetch item by id
    ///
    /// - Parameter id: id to fetch
    /// - Returns: type T
    internal subscript(with id: Int32, in uuid: String) -> T? {
        return database.queue.inDatabase { T.fetchOne($0, key: ["cid": uuid, "eventId": id]) }
    }
    
    /// Fetch item at position
    ///
    /// - Parameter at: posiiton in database
    /// - Returns: type T
    internal subscript(at position: Int, in uuid: String) -> T? {
        return database.queue.inDatabase {
            T.all()
                .filter(sql: "cid = ?", arguments: [uuid])
                .order(sql: "eventId ASC")
                .limit(1, offset: position)
                .fetchOne($0)
            
        }
    }
    
    // MARK:
    // MARK: Create
    
    /// Create table of type T
    ///
    /// - Returns: success/fail
    /// - Throws: CRUD.Errors
    internal func createTable(in database: Database.Provider) throws {
        try database.execute("CREATE TABLE events (" +
            "cid TEXT NOT NULL, " +
            "eventId INTEGER NOT NULL, " +
            "[from] TEXT, " +
            "timestamp DATETIME NOT NULL, " +
            "type INTEGER NOT NULL, " +
            "text TEXT, " +
            "body TEXT NOT NULL, " +
            "payload BLOB, " +
            "isDraft BOOLEAN NOT NULL, " +
            "draftSentCounterpart INTEGER, " +
            "distribution BLOB NOT NULL, " +
            "markedAsSeen BOOLEAN NOT NULL, " +
            "PRIMARY KEY (cid, eventId)" +
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
    
    /// Get draft events from event that have been sent
    internal func getDraft(_ id: Int32, in uuid: String) -> T? {
        return database.queue.inDatabase { database in
            return T
                .all()
                .filter(sql: "cid = ? AND draftSentCounterpart = ?", arguments: [uuid, id])
                .fetchOne(database)
        }
    }
    
    /// Get last event id
    ///
    /// - Parameter uuid: conversation to get last event id
    /// - Returns: success/fail
    /// - Throws: CRUDErrors
    internal func lastEventId(in uuid: String) -> Int32? {
        return database.queue.inDatabase {
            Int32.fetchOne($0, T.select(sql: "MAX(eventId)").filter(sql: "cid = ?", arguments: [uuid]))
        }
    }
}
