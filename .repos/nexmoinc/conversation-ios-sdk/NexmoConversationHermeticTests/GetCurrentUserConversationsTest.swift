//
//  GetCurrentUserConversationsTest.swift
//  NexmoConversation
//
//  Created by Ivan on 02/02/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import XCTest
import Quick
import Nimble
import NexmoConversation

class GetCurrentUserConversationsTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    let client = ConversationClient.instance
    
    override func spec() {
        
        beforeEach {
            
        }
        
        afterEach {
            BasicOperations.logout(client: self.client)
        }
        
        context("get current user conversations") {
            it("should pass") {
                BasicOperations.login(with: self.client)
                
                var conversationResponse: [ConversationPreviewModel]?
                
                _ = self.client.conversation.all().subscribe(onNext: { conversation in
                    conversationResponse = conversation
                }, onError: { _ in
                    fail()
                })
                
                expect(conversationResponse?.count).toEventuallyNot(equal(0), timeout: 5, pollInterval: 1)
            }
            
            it("should fail when malformed JSON is returned by server") {
                let token = TokenBuilder(response: .createGetInfoConversations).get.build
                
                BasicOperations.login(with: self.client, using: token)
                
                var responseError: Error?
                
                _ = self.client.conversation.all().subscribe(onError: { error in
                    responseError = error
                })
                
                expect(responseError).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
            }
        }
    }
}
