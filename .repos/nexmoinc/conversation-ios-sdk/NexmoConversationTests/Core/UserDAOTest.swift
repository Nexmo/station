//
//  UserDAOTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 21/04/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class UserDAOTest: QuickSpec {
    
    let mock = SimpleMockDatabase()
    
    let databaseManager = ConversationClient.instance.databaseManager
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("insert users to database") {
            expect { try self.databaseManager.user.deleteAll() }.toNot(throwAssertion())
            expect { try self.databaseManager.user.insert(self.mock.user1) }.toNot(throwAssertion())
            expect { try self.databaseManager.user.insert(self.mock.user2) }.toNot(throwAssertion())
            
            expect(self.databaseManager.user.all.count) == 2
            expect(self.databaseManager.user[self.mock.user1.rest.uuid]).toNot(beNil())
        }
        
        it("creates the user table") {
            Database.default.queue.inDatabase { database -> Void in
                expect { try self.databaseManager.user.createTable(in: database) }.toNot(throwAssertion())
                
                return ()
            }
        }
        
        it("delete all users from table") {
            expect { try self.databaseManager.user.deleteAll() }.toNot(throwAssertion())
        }
        
        it("gets all three models ") {
            expect { try self.databaseManager.user.insert(self.mock.user1) }.toNot(throwAssertion())
            expect { try self.databaseManager.user.insert(self.mock.user2) }.toNot(throwAssertion())
            expect { try self.databaseManager.user.insert(self.mock.user3) }.toNot(throwAssertion())
            
            expect(self.databaseManager.user.all.count) == 3
        }
        
        it("get one object from the above insert") {
            expect(self.databaseManager.user[self.mock.user3.rest.uuid]).toNot(beNil())
        }
    }
}
