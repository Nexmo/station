//
//  ModifyDBEventOperationTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 21/06/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxBlocking
import RxTest
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class ModifyDBEventOperationTest: QuickSpec {

    let client = ConversationClient.instance

    // MARK:
    // MARK: Test

    override func spec() {
        it("removes a deleted event and its content") {
            do {
                // clear database
                try self.client.databaseManager.clear()

                // Add text event
                try self.client.databaseManager.event.insert(SimpleMockDatabase().DBEvent2)

                // build delete event
                let json = self.json(path: .deleteEvent)
                guard let event = Event(json: json) else { return fail() }

                // delete event
                guard let result = try ModifyDBEventOperation(
                    event,
                    cache: self.client.objectCache,
                    database: self.client.databaseManager
                ).perform().debug().toBlocking().single() else { return fail() }

                expect(result) == ()
            } catch let error {
                fail(error.localizedDescription)
            }
        }

        it("fails to remove am deleted event and its content") {
            do {
                try self.client.databaseManager.clear()
            } catch let error {
                fail(error.localizedDescription)
            }
        }
    }
}
