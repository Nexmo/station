//
//  XCTest+Helper.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 14/06/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
import XCTest
@testable import NexmoConversation

extension XCTestCase {

    // MARK:
    // MARK: Setup

    open override func setUp() {
        super.setUp()

        setupStubs()
    }

    // MARK:
    // MARK: Private - Helper

    private func setupStubs() {
        if let id = UIDevice.current.identifierForVendor?.uuidString {
            stubOk(with: PushNotificationRouter.deleteDeviceToken(id: id).urlRequest)
        }

        stub(json: [:], request: ConversationRouter.allUser(id: "usr-123").urlRequest)
    }
}
