//
//  NexmoConversationE2ETests.swift
//  NexmoConversationE2ETests
//
//  Created by Shams Ahmed on 13/12/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import XCTest
import Quick
import Nimble
import NexmoConversation

class AccountTest: QuickSpec {
    
    let client = ConversationClient.instance
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        afterEach {
            self.logout()
            
            expect(self.client.account.token).toEventually(beNil())
        }
        
        it("should login to capi") {
            self.login {
                if $0 != nil {
                    fail()
                }
            }

            expect(self.client.account.state.value).toEventuallyNot(equal(AccountController.State.loggedOut))
            expect(self.client.account.token).toEventuallyNot(beNil())
        }

        it("should logout of capi after user has logged in") {
            var hasLoggedIn = false
            
            self.login { state in
                expect(state).to(beNil())
                
                hasLoggedIn = true
                
                self.logout()
            }
            
            expect(hasLoggedIn).toEventually(beTrue())
            expect(self.client.account.token).toEventually(beNil(), timeout: 2.5)
        }
    }
    
    // MARK:
    // MARK: Helper
    
    private func login(_ callback: @escaping ((ConversationClient.LoginResult?) -> Void)) {
        let token = String(arc4random())
        
        self.client.login(with: token, { state in callback(state) })
    }
    
    private func logout() {
        self.client.logout()
    }
}
