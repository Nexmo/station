//
//  DatabaseManager.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 30/03/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/// Database Manager access
internal struct DatabaseManager {
    
    /// Main DB
    private let database = Database.default
    
    /// Event DAO
    internal let event: EventDAO
    
    /// Conversation DAO
    internal let conversation: ConversationDAO
    
    /// Task DAO
    internal let task: TaskDAO
    
    /// User DAO
    internal let user: UserDAO
    
    /// Member DAO
    internal let member: MemberDAO
    
    /// Receipt DAO
    internal let receipt: ReceiptDAO
    
    // MARK:
    // MARK: Initializers
    
    internal init() {
        event = EventDAO(database: database)
        conversation = ConversationDAO(database: database)
        task = TaskDAO(database: database)
        user = UserDAO(database: database)
        member = MemberDAO(database: database)
        receipt = ReceiptDAO(database: database)
        
        setup()
    }
    
    // MARK:
    // MARK: Private - Setup
    
    private func setup() {
        _ = try? migratorDatabase()
    }
    
    // MARK:
    // MARK: Database
    
    /// Remove the database from disk space
    internal func clear() throws {
        try database.queue.inDatabase { database in
            try DBTask.deleteAll(database)
            try DBUser.deleteAll(database)
            try DBReceipt.deleteAll(database)
            try DBMember.deleteAll(database)
            try DBEvent.deleteAll(database)
            try DBConversation.deleteAll(database)
        }
    }
    
    /// Create tables
    private func migratorDatabase() throws {
        // Version 1.0.0 Database
        try database.migrate("1.0.0") { database in
            try? self.task.createTable(in: database)
            try? self.user.createTable(in: database)
            try? self.receipt.createTable(in: database)
            try? self.member.createTable(in: database)
            try? self.event.createTable(in: database)
            try? self.conversation.createTable(in: database)
        }
    }
}
