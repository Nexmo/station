//
//  AccountServiceTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 31/10/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation

import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class AccountServiceTest: QuickSpec {
    
    let client = NetworkController(token: "token")
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("check account service for nil") {
            expect(self.client.accountService).toNot(beNil())
        }
    }
}
