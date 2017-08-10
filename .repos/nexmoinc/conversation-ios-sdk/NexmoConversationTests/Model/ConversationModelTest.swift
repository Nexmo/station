//
//  ConversationModelTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 02/08/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class ConversationModelTest: QuickSpec {

    // MARK:
    // MARK: Test

    override func spec() {
        it("compares conversation model") {
            let conversation = SimpleMockDatabase().conversation1.rest

            let result = conversation == conversation

            expect(result) == true
        }

        it("creates a full conversation") {
            let json = self.json(path: .fullConversation)
            let conversation = ConversationModel(json: json)

            expect(conversation).toNot(beNil())
        }

        it("fails with no id in conversation") {
            let conversation = ConversationModel(json: [:])

            expect(conversation).to(beNil())
        }
    }
}
