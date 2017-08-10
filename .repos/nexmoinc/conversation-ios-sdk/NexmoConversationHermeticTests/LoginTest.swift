//
//  LoginTest.swift
//  NexmoConversation
//
//  Created by Ivan on 17/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import XCTest
import Quick
import Nimble
import NexmoConversation
import RxSwift
import RxBlocking
import RxTest

class LoginTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    let client = ConversationClient.instance
    
    override func spec() {
        beforeEach {
            
        }
        
        afterEach {
            BasicOperations.logout(client: self.client)
        }
        
        context("login") {
            
            it("should pass") {
                var hasLoggedIn = false
                
                self.client.login(with: "token", {
                    if $0 != .success {
                        fail()
                    }
                    
                    hasLoggedIn = true
                })
                
                expect(self.client.account.state.value).toEventuallyNot(
                    equal(AccountController.State.loggedOut),
                    timeout: 5,
                    pollInterval: 1
                )
                
                expect(hasLoggedIn).toEventually(beTrue())
            }
            
            it("should pass when user logins after logout") {
                var hasLoggedIn = false
                
                self.client.login(with: "token", {
                    if $0 != .success {
                        fail()
                    }
                    
                    hasLoggedIn = true
                })
                
                expect(self.client.account.state.value).toEventuallyNot(
                    equal(AccountController.State.loggedOut),
                    timeout: 5,
                    pollInterval: 1
                )
                
                expect(hasLoggedIn).toEventually(beTrue())
                
                self.client.logout()
                
                hasLoggedIn = false
                
                expect(self.client.account.state.value).toEventually(
                    equal(AccountController.State.loggedOut),
                    timeout: 5,
                    pollInterval: 1
                )
                
                self.client.login(with: "token", {
                    if $0 != .success {
                        fail()
                    }
                    
                    hasLoggedIn = true
                })
                
                expect(self.client.account.state.value).toEventuallyNot(
                    equal(AccountController.State.loggedOut),
                    timeout: 5,
                    pollInterval: 1
                )
                
                expect(hasLoggedIn).toEventually(beTrue())
            }
            
            it("should fail when users tries to log in with invalid token") {
                guard let token = ["template": "system_error_invalid-token"].JSONString else { return fail() }
                
                var responseStatus: ConversationClient.LoginResult?
                
                self.client.login(with: token, { status in responseStatus = status })
                
                expect(self.client.account.state.value).toEventually(
                    equal(AccountController.State.loggedOut),
                    timeout: 5,
                    pollInterval: 1
                )
                
                expect(responseStatus).toEventually(equal(ConversationClient.LoginResult.invalidToken))
            }
        }
    }
}
