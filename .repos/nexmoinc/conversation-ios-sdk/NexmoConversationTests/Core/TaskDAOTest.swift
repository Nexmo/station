//
//  TaskDAOTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 03/04/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class TaskDAOTest: QuickSpec {
    
    let mock = SimpleMockDatabase()
    
    let databaseManager = ConversationClient.instance.databaseManager
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("fetches number of pending task") {
            let event = self.mock.DBEvent1
            let task = DBTask(.send)
            
            task.related = EventBase.uuid(from: event.id, in: event.cid)
            
            expect { try self.databaseManager.event.insert(event) }.toNot(throwAssertion())
            expect { try self.databaseManager.task.insert(task) }.toNot(throwAssertion())
            expect(self.databaseManager.task.pending.isEmpty) == false
            expect { try self.databaseManager.task.deleteAll() }.toNot(throwAssertion())
        }
        
        it("fetches number of pending task that are not over max retry count") {
            let event = self.mock.DBEvent2
            let task = DBTask(.send)
            
            task.retryCount = 5
            task.related = EventBase.uuid(from: event.id, in: event.cid)
            
            expect { try self.databaseManager.event.insert(event) }.toNot(throwAssertion())
            expect { try self.databaseManager.task.insert(task) }.toNot(throwAssertion())
            expect(self.databaseManager.task.pending.isEmpty) == true
        }
        
        it("fetches number of active task") {
            let event = self.mock.DBEvent1
            let task = DBTask(.send)
            
            task.beingProcessed = true
            task.related = EventBase.uuid(from: event.id, in: event.cid)
            
            expect { try self.databaseManager.event.insert(event) }.toNot(throwAssertion())
            expect { try self.databaseManager.task.insert(task) }.toNot(throwAssertion())
            expect(self.databaseManager.task.active.isEmpty) == false
            expect { try self.databaseManager.task.deleteAll() }.toNot(throwAssertion())
        }
        
        it("fetches number of active task should return zero") {
            let event = self.mock.DBEvent1
            let task = DBTask(.send)
            
            task.beingProcessed = false
            task.related = EventBase.uuid(from: event.id, in: event.cid)
            
            expect { try self.databaseManager.event.insert(event) }.toNot(throwAssertion())
            expect { try self.databaseManager.task.insert(task) }.toNot(throwAssertion())
            expect(self.databaseManager.task.active.isEmpty) == true
        }
        
        it("creates table for task") {
            Database.default.queue.inDatabase { database -> Void in
                expect { try self.databaseManager.task.createTable(in: database) }.toNot(throwAssertion())
                
                return ()
            }
        }
        
        it("removes all records") {
            expect { try self.databaseManager.task.deleteAll() }.toNot(throwAssertion())
        }
        
        it("fetches one recond per type") {
            let event = self.mock.DBEvent1
            let task1 = DBTask(.send)
            let task2 = DBTask(.indicateDelivered)
            let task3 = DBTask(.indicateSeen)
            let task4 = DBTask(.delete)
            
            task1.related = EventBase.uuid(from: event.id, in: event.cid)
            task2.related = EventBase.uuid(from: event.id, in: event.cid)
            task3.related = EventBase.uuid(from: event.id, in: event.cid)
            task4.related = EventBase.uuid(from: event.id, in: event.cid)
            
            expect { try self.databaseManager.task.insert(task1) }.toNot(throwAssertion())
            expect { try self.databaseManager.task.insert(task2) }.toNot(throwAssertion())
            expect { try self.databaseManager.task.insert(task3) }.toNot(throwAssertion())
            expect { try self.databaseManager.task.insert(task4) }.toNot(throwAssertion())
            expect(self.databaseManager.task[.send]).toNot(beNil())
            expect(self.databaseManager.task[.indicateDelivered]).toNot(beNil())
            expect(self.databaseManager.task[.indicateSeen]).toNot(beNil())
            expect(self.databaseManager.task[.delete]).toNot(beNil())
            expect { try self.databaseManager.task.deleteAll() }.toNot(throwAssertion())
        }
        
        it("clears all task") {
            let event = self.mock.DBEvent1
            let task1 = DBTask(.send)
            let task2 = DBTask(.send)
            
            task1.beingProcessed = true
            task1.related = EventBase.uuid(from: event.id, in: event.cid)
            task2.beingProcessed = true
            task2.related = EventBase.uuid(from: event.id, in: event.cid)

            expect { try self.databaseManager.event.insert(event) }.toNot(throwAssertion())
            expect { try self.databaseManager.task.insert(task1) }.toNot(throwAssertion())
            expect { try self.databaseManager.task.insert(task2) }.toNot(throwAssertion())
            expect { try self.databaseManager.task.clear() }.toNot(throwAssertion())
            expect(self.databaseManager.task.active.isEmpty) == true
        }
    }
}
