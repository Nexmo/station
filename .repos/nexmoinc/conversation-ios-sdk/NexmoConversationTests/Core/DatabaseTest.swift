//
//  DatabaseTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 25/04/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class DatabaseTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("creates a queue for testing") {
            let database = Database.default
            
            expect(database.queue.path.isEmpty) == false
        }
        
        it("creates a real queue for testing") {
            var lock = true
            
            Environment.default.disableTestChecking {
                let database = Database()
                
                expect(database.queue.path.isEmpty) == false
                
                lock = false
            }
            
            expect(lock).toEventually(beFalse())
        }
    }
}
