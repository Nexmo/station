//
//  DatabaseManagerTest.swift
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

internal class DatabaseManagerTest: QuickSpec {
    
    let manager = DatabaseManager()
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("wipes out all the tables") {
            expect { try self.manager.clear() }.toNot(throwAssertion())
        }
    }
}
