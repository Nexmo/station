//
//  ConversationClientInterop.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 07/08/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
@testable import NexmoConversation

internal class ConversationClientInterop: NSObject {

    // MARK:
    // MARK: Account

    /// set test suer as logged in
    static func setAsLoggedIn(with client: ConversationClient) {
        let session = Session(id: "1", userId: "usr-1", name: "test user")

        client.account.state.value = .loggedIn(session)
    }
}
