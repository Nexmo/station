//
//  MemberDAOTest.swift
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

internal class MemberDAOTest: QuickSpec {
    
    let mock = SimpleMockDatabase()
    
    let databaseManager = ConversationClient.instance.databaseManager
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("inserts/updates member for a conversation") {
            expect { try self.databaseManager.member.insert(self.mock.DBMember1) }.toNot(throwAssertion())
            expect { try self.databaseManager.member.insert(self.mock.DBMember2) }.toNot(throwAssertion())
        }
        
        it("fetches one member for a conversation") {
            expect(self.databaseManager.member[self.mock.DBMember1.rest.id]).toNot(beNil())
        }
        
        it("fetches all members") {
            expect(self.databaseManager.member.all.isEmpty) == false
        }
        
        it("creates member table") {
            Database.default.queue.inDatabase { database -> Void in
                expect { try self.databaseManager.member.createTable(in: database) }.toNot(throwAssertion())
                
                return ()
            }
        }
        
        it("delete all members from the table") {
            expect { try self.databaseManager.member.deleteAll() }.toNot(throwAssertion())
            expect(self.databaseManager.member[self.mock.DBMember1.rest.id]).to(beNil())
        }
    }
}
