//
//  Database.swift
//  NexmoConversation
//
//  Created by James Green on 26/08/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import GRDB

/// Database
internal struct Database {
    
    /// Nice helper to avoid importing GRDB all around the codebase
    internal typealias Provider = GRDB.Database
    
    // MARK:
    // MARK: Singleton
    
    /// Static accessor for database singleton.
    internal static let `default`: Database = { return Database() }()

    // MARK:
    // MARK: Static
    
    /// DB path
    private static var path: String {
        // Unit testing is run in sandbox mode, document directory are off limits
        guard !Environment.inTesting else { return "\(NSTemporaryDirectory())\(ProcessInfo.processInfo.globallyUniqueString)" }
        
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        return documents + "/NexmoSDK.sqlite"
    }
    
    // MARK:
    // MARK: Queue
    
    /// Read/Write queue
    internal let queue: DatabaseQueue = {
        // if it fails, will fail back to in-memory queue
        guard let diskSpaceQueue = try? DatabaseQueue(path: Database.path) else { return DatabaseQueue() }
        
        return diskSpaceQueue
    }()

    // MARK:
    // MARK: Initializers
    
    internal init() {
   
    }
    
    // MARK:
    // MARK: Migrator
    
    internal func migrate(_ version: String, _ closure: @escaping (Database.Provider) -> Void) throws {
        var migrator = DatabaseMigrator()
        migrator.registerMigration(version) { closure($0) }
        
        try migrator.migrate(queue)
    }
}
