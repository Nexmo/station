//
//  ReceiptDAOTest.swift
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

internal class ReceiptDAOTest: QuickSpec {
    
    let mock = SimpleMockDatabase()
    
    let databaseManager = ConversationClient.instance.databaseManager
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("inserts/updates receipts for events") {
            expect { try self.databaseManager.receipt.insert(self.mock.receipt1) }.toNot(throwAssertion())
            expect { try self.databaseManager.receipt.insert(self.mock.receipt2) }.toNot(throwAssertion())
        }
        
        it("fetches receipts for a conversation") {
            expect(self.databaseManager.receipt[in: self.mock.receipt2.conversationId].isEmpty) == false
        }
        
        it("fetches all member receipts") {
            expect(self.databaseManager.receipt[self.mock.receipt2.memberId].isEmpty) == false
        }
        
        it("fetches receipts for a event") {
            expect(self.databaseManager.receipt[self.mock.receipt2.memberId, for: self.mock.receipt1.eventId]).toNot(beNil())
        }
        
        it("fetches all receipts from a event id") {
            expect(self.databaseManager.receipt[in: self.mock.receipt1.conversationId, for: self.mock.receipt1.eventId].isEmpty) == false
        }
        
        it("creates receipt table") {
            Database.default.queue.inDatabase { database -> Void in
                expect { try self.databaseManager.receipt.createTable(in: database) }.toNot(throwAssertion())
                
                return ()
            }
        }
        
        it("delete all receipts from the table") {
            expect { try self.databaseManager.receipt.deleteAll() }.toNot(throwAssertion())
            expect(self.databaseManager.receipt[self.mock.receipt2.memberId].isEmpty) == true
        }
    }
}
