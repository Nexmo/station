//
//  DatabaseObserver.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 19/12/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import GRDB
import RxSwift
@testable import NexmoConversation

internal class DatabaseObserver: TransactionObserver {
    
    /// List of table changes
    let updatedTables: Variable<String> = Variable<String>("")
    
    // MARK:
    // MARK: TransactionObserverType
    
    func observes(eventsOfKind eventKind: DatabaseEventKind) -> Bool {
        return true
    }
    
    func databaseDidChange(with event: DatabaseEvent) {
        updatedTables.value = event.tableName
    }
    
    func databaseWillCommit() throws {
        
    }
    
    func databaseDidCommit(_ db: GRDB.Database) {
        
    }
    
    func databaseDidRollback(_ db: GRDB.Database) {
        
    }
}
