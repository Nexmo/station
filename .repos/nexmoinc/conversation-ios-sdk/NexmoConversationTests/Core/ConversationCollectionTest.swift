//
//  ConversationCollectionTest.swift
//  NexmoConversation
//
//  Created by shams ahmed on 12/07/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

import UIKit
import Quick
import Nimble
import Mockingjay
import RxSwift
import RxTest
import RxBlocking
@testable import NexmoConversation

internal class ConversationCollectionTest: QuickSpec {
    
    let network = NetworkController(token: "token")
    lazy var account: AccountController = { AccountController(network: self.network) }()
    lazy var event: EventController = { EventController(network: self.network) }()
    let database = DatabaseManager()
    lazy var conversationController: ConversationController = { ConversationController(network: self.network, account: self.account) }()
    lazy var membership: MembershipController = { MembershipController(network: self.network) }()
    
    lazy var cache: CacheManager = { CacheManager(
        databaseManager: self.database,
        eventController: self.event,
        account: self.account,
        conversation: self.conversationController,
        membershipController: self.membership)
    }()
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        
        // MARK:
        // MARK: Test
        
        it("increases count for new conversations") {
            let queue = EventQueue(cache: self.cache, event: self.event, database: self.database)
            
            self.cache.eventQueue = queue
            
            let collection = ConversationCollection(cache: self.cache)
            
            expect(collection.count) == 0
            
            _ = SimpleMockDatabase()
            collection.refetch()
            
            expect(collection.count) == 2
        }
        
        it("fails to increases count for new conversations") {
            let queue = EventQueue(cache: self.cache, event: self.event, database: self.database)
            
            self.cache.eventQueue = queue
            
            let collection = ConversationCollection(cache: nil)
            
            expect(collection.count) == 0
            
            _ = SimpleMockDatabase()
            collection.refetch()
            
            expect(collection.count) == 0
            expect { _ = collection.index(after: 0) }.to(throwAssertion())
            expect { _ = collection[1232223] }.to(throwAssertion())
        }
        
        it("fails to fetch conversation with out of bound error") {
            let queue = EventQueue(cache: self.cache, event: self.event, database: self.database)
            
            let cache = self.cache
            cache.eventQueue = queue
            
            let collection = ConversationCollection(cache: cache)
        
            expect { _ = collection[10000] }.to(throwAssertion())
        }
        
        it("inserts a new conversation") {
            let queue = EventQueue(cache: self.cache, event: self.event, database: self.database)
            
            self.cache.eventQueue = queue
            
            let collection = ConversationCollection(cache: self.cache)
            
            var isInsert = false
            
            _ = collection.asObservable.subscribe(onNext: { change in
                switch change {
                case .inserted(_): isInsert = true
                default: fail()
                }
            })
            
            collection.value = .inserted([Conversation(
                SimpleMockDatabase().conversation1,
                eventController: self.event,
                databaseManager: self.database,
                eventQueue: queue,
                account: self.account,
                conversationController: self.conversationController,
                membershipController: self.membership)], .new
            )
            
            expect(isInsert).toEventually(beTrue())
        }
        
        it("updates a conversation") {
            let queue = EventQueue(cache: self.cache, event: self.event, database: self.database)
            
            self.cache.eventQueue = queue
            
            let collection = ConversationCollection(cache: self.cache)
            
            var isUpdated = false
            
            _ = collection.asObservable.subscribe(onNext: { change in
                switch change {
                case .updated(_): isUpdated = true
                default: fail()
                }
            })
            
            collection.value = .updated([Conversation(
                SimpleMockDatabase().conversation1,
                eventController: self.event,
                databaseManager: self.database,
                eventQueue: queue,
                account: self.account,
                conversationController: self.conversationController,
                membershipController: self.membership)]
            )
            
            expect(isUpdated).toEventually(beTrue())
        }
        
        it("deletes a conversation") {
            let queue = EventQueue(cache: self.cache, event: self.event, database: self.database)
            
            self.cache.eventQueue = queue
            
            let collection = ConversationCollection(cache: self.cache)
            
            var isDeleted = false
            
            _ = collection.asObservable.subscribe(onNext: { change in
                switch change {
                case .deleted(_): isDeleted = true
                default: fail()
                }
            })
            
            collection.value = .deleted([Conversation(
                SimpleMockDatabase().conversation1,
                eventController: self.event,
                databaseManager: self.database,
                eventQueue: queue,
                account: self.account,
                conversationController: self.conversationController,
                membershipController: self.membership)]
            )
            
            expect(isDeleted).toEventually(beTrue())
        }
        
        it("returns a conversation for safe index subscript") {
            let queue = EventQueue(cache: self.cache, event: self.event, database: self.database)
            
            self.cache.eventQueue = queue
            
            let collection = ConversationCollection(cache: self.cache)
            
            _ = SimpleMockDatabase()
            collection.refetch()
            
            expect(collection[safe: 0]).toNot(beNil())
        }

        it("inserts a new conversation") {
            let queue = EventQueue(cache: self.cache, event: self.event, database: self.database)

            self.cache.eventQueue = queue

            let collection = ConversationCollection(cache: self.cache)

            var gotANewCovnersation = false

            _ = collection.asObservable.subscribe(onNext: { _ in
                gotANewCovnersation = true
            })

            collection.value = .inserted([Conversation(
                SimpleMockDatabase().conversation1,
                eventController: self.event,
                databaseManager: self.database,
                eventQueue: queue,
                account: self.account,
                conversationController: self.conversationController,
                membershipController: self.membership)], .new
            )

            expect(collection.value).toNot(beNil())
            expect(gotANewCovnersation).toEventually(beTrue())
        }

        it("inserts a new conversation with reason invited by") {
            let queue = EventQueue(cache: self.cache, event: self.event, database: self.database)

            self.cache.eventQueue = queue

            let collection = ConversationCollection(cache: self.cache)

            var gotANewCovnersation = false

            _ = collection.asObservable.subscribe(onNext: { _ in
                gotANewCovnersation = true
            })

            collection.value = .inserted([Conversation(
                SimpleMockDatabase().conversation1,
                eventController: self.event,
                databaseManager: self.database,
                eventQueue: queue,
                account: self.account,
                conversationController: self.conversationController,
                membershipController: self.membership)], .invitedBy(Member(data: SimpleMockDatabase().DBMember1))
            )

            expect(collection.value).toNot(beNil())
            expect(gotANewCovnersation).toEventually(beTrue())
        }
    }
}
