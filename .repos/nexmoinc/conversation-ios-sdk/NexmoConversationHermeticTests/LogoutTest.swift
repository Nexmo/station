//
//  LogoutTest.swift
//  NexmoConversation
//
//  Created by Ivan on 17/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import XCTest
import Quick
import Nimble
import NexmoConversation

class LogoutTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    let client = ConversationClient.instance
    
    override func spec() {
        
        afterEach {
            BasicOperations.logout(client: self.client)
        }
        
        context("logout") {
            it("should pass") {
                BasicOperations.login(with: self.client)
                
                self.client.logout()
                
                expect(self.client.account.state.value == AccountController.State.loggedOut) == true
            }
        }
    }
}
