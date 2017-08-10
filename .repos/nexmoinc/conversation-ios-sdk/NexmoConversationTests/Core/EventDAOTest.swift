//
//  EventDAOTest.swift
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

internal class EventDAOTest: QuickSpec {
    
    let dao = EventDAO(database: Database.default)
    
    let mock = SimpleMockDatabase()
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("delete a event") {
            let event = self.mock.DBEvent1
            
            expect { try self.dao.insert(event) }.toNot(throwAssertion())
            expect { try self.dao.delete(event) }.toNot(throwAssertion())
        }
        
        it("deletes all events") {
            expect { try self.dao.insert(self.mock.DBEvent1) }.toNot(throwAssertion())
            expect { try self.dao.deleteAll() }.toNot(throwAssertion())
            
            expect(self.dao[at: 1, in: self.mock.DBEvent1.cid]).to(beNil())
        }
        
        it("insert a event") {
            expect { try self.dao.insert(self.mock.DBEvent1) }.toNot(throwAssertion())
            expect { try self.dao.insert(self.mock.DBEvent2) }.toNot(throwAssertion())
            expect { try self.dao.insert(self.mock.DBEvent3) }.toNot(throwAssertion())
            
            let events = self.dao[in: self.mock.DBEvent1.cid]
            
            expect(events.count) == 3
        }
        
        it("update a event") {
            expect { try self.dao.deleteAll() }.toNot(throwAssertion())
            
            expect { try self.dao.update(self.mock.DBEvent1) }.toNot(throwAssertion())
            expect { try self.dao.update(self.mock.DBEvent2) }.toNot(throwAssertion())
            expect { try self.dao.update(self.mock.DBEvent3) }.toNot(throwAssertion())
            
            let events = self.dao[in: self.mock.DBEvent1.cid]
            
            expect(events.count) == 3
        }
        
        it("gets a event") {
            expect { try self.dao.insert(self.mock.DBEvent1) }.toNot(throwAssertion())
            expect(self.dao[at: Int(self.mock.DBEvent1.id), in: self.mock.DBEvent1.cid]).toNot(beNil())
        }
        
        it("gets a draft event") {
            let event = self.mock.DBEvent1
            event.isDraft = true
            event.draftSentCounterpart = self.mock.DBEvent1.id
            
            expect { try self.dao.insert(event) }.toNot(throwAssertion())
            expect(self.dao.getDraft(self.mock.DBEvent1.id, in: self.mock.DBEvent1.cid)).toNot(beNil())
        }
        
        it("gets all events") {
            expect { try self.dao.insert(self.mock.DBEvent1) }.toNot(throwAssertion())
            expect { try self.dao.insert(self.mock.DBEvent2) }.toNot(throwAssertion())
            expect { try self.dao.insert(self.mock.DBEvent3) }.toNot(throwAssertion())
            
            let events = self.dao[in: self.mock.DBEvent1.cid]
            
            expect(events.count) == 3
        }
        
        it("fetches event by id") {
            expect(self.dao[with: self.mock.DBEvent1.id, in: self.mock.DBEvent1.cid]).toNot(beNil())
        }
        
        it("creates the event table") {
            Database.default.queue.inDatabase { database -> Void in
                expect { try self.dao.createTable(in: database) }.toNot(throwAssertion())
                
                return ()
            }
        }
        
        it("get last event id") {
            expect { try self.dao.insert(self.mock.DBEvent1) }.toNot(throwAssertion())
            expect { try self.dao.insert(self.mock.DBEvent2) }.toNot(throwAssertion())
            expect { try self.dao.insert(self.mock.DBEvent3) }.toNot(throwAssertion())
            
            expect(self.dao.lastEventId(in: self.mock.DBEvent3.cid)) == 3
        }
    }
}
