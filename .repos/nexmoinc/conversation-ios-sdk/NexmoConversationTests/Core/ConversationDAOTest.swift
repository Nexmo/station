//
//  ConversationDAOTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 31/03/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class ConversationDAOTest: QuickSpec {
    
    let mock = SimpleMockDatabase()
    
    let dao = ConversationClient.instance.databaseManager.conversation
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("fetches all dirty conversations ") {
            let conversation = self.mock.conversation1
            conversation.dataIncomplete = true
            conversation.requiresSync = true
            
            expect { try self.dao.insert(conversation) }.toNot(throwAssertion())
            expect(self.dao.dirtyUuids.isEmpty) == false
        }
        
        it("fetches incomplete uuids") {
            let conversation = self.mock.conversation1
            conversation.dataIncomplete = true
            conversation.requiresSync = true
            
            expect { try self.dao.insert(conversation) }.toNot(throwAssertion())
            expect(self.dao.dataIncompleteUuids.isEmpty) == false
        }
        
        it("fetches all conversations") {
            let conversation = self.mock.conversation1
            
            expect { try self.dao.insert(conversation) }.toNot(throwAssertion())
            expect(self.dao.all.isEmpty) == false
        }
        
        it("fetches one conversation") {
            let conversation = self.mock.conversation1
            
            expect { try self.dao.insert(conversation) }.toNot(throwAssertion())
            expect(self.dao[conversation.rest.uuid]).toNot(beNil())
        }
        
        it("creates conversation table") {
            Database.default.queue.inDatabase { database -> Void in
                expect { try self.dao.createTable(in: database) }.toNot(throwAssertion())
                
                return ()
            }
        }

        it("deletes all reconds from database") {
            expect { try self.dao.deleteAll() }.toNot(throwAssertion())
        }
    }
}
