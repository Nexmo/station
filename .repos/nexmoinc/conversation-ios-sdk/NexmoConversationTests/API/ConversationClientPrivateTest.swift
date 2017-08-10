//
//  ConversationClientPrivateTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 30/05/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class ConversationClientPrivateTest: QuickSpec {

    // MARK:
    // MARK: Test

    override func spec() {
        it("leave all conversation helper") {
            let client = ConversationClient.instance
            let conversation = SimpleMockDatabase().conversation1

            expect { try client.databaseManager.conversation.insert(conversation) }.toNot(throwAssertion())

            client.leaveAllConversations()

            // TODO: look at testing all conversation have been left
        }
    }
}
