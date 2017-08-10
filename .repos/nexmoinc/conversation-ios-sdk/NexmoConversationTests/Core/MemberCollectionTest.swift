//
//  MemberCollectionTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 21/07/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class MemberCollectionTest: QuickSpec {

    // MARK:
    // MARK: Test

    override func spec() {
        it("creates collection from conversation") {
            _ = SimpleMockDatabase()
            let databaseManager = DatabaseManager()
            let collection = MemberCollection(conversationUuid: "con-1", databaseManager: databaseManager)

            collection.refresh()

            expect(collection.count) > 0
            expect { _ = collection[0] }.toNot(throwAssertion())
            expect(collection["mem-123"]).toNot(beNil())
        }

        it("creates collection from event") {
            let mock = SimpleMockDatabase()
            let event = TextEvent(data: mock.DBEvent1)
            let collection = MemberCollection(event: event)

            collection.refresh()

            expect(collection.count) == 0
            expect(collection.allUsers.isEmpty) == true
        }
    }
}
