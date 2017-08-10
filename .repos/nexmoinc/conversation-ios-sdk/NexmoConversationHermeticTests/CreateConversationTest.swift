//
//  CreateConversationTest.swift
//  NexmoConversation
//
//  Created by Ivan on 17/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import NexmoConversation
import RxSwift
import RxTest
import RxBlocking

class CreateConversationTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    let client = ConversationClient.instance
    
    override func spec() {
        
        beforeEach {
            
        }
        
        afterEach {
            BasicOperations.logout(client: self.client)
        }
        
        context("create conversation") {
            it("should pass") {
                // use conversationAdded handler in future
                BasicOperations.login(with: self.client)
                
                var networkError: NetworkErrorProtocol?
                
                self.client.unhandledError
                    .subscribe(onNext: { networkError = $0 })
                    .addDisposableTo(self.client.disposeBag)
                
                let model = ConversationController.CreateConversation(name: "CON-new-test")
                var conversation: Conversation?

                do {
                    conversation = try self.client.conversation.new(model).toBlocking().first()
                } catch let error {
                    fail(error.localizedDescription)
                }

                expect(conversation?.uuid.isEmpty).toEventually(beFalse(), timeout: 5, pollInterval: 1)
                expect(networkError).toEventually(beNil())
            }
            
            it("should fail when user is not logged in") {
                self.client.addAuthorization(with: "")
                let model = ConversationController.CreateConversation(name: "CON-new-test")
                let newConversation = try? self.client.conversation.new(model).toBlocking().first()
                
                expect(self.client.account.state.value) == AccountController.State.loggedOut
                expect(newConversation).to(beNil())
            }
            
            it("should fail when malformed JSON is returned by server") {
                var networkError: NetworkErrorProtocol?
                
                self.client.unhandledError
                    .subscribe(onNext: { networkError = $0 })
                    .addDisposableTo(self.client.disposeBag)
                
                let token = TokenBuilder(response: .createGetInfoConversations).post.build
                
                BasicOperations.login(with: self.client, using: token)
                
                let model = ConversationController.CreateConversation(name: "CON-new-test")
                var responseError: Error?
                
                _ = self.client.conversation.new(model).subscribe(onError: { error in
                    responseError = error
                })
                
                expect(responseError).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(networkError).toEventuallyNot(beNil())
                expect(networkError?.localizedTitle.isEmpty).toEventuallyNot(beTrue())
                expect(networkError?.localizedDescription.isEmpty).toEventuallyNot(beTrue())
                expect(networkError?.endpointURL?.isEmpty).toEventuallyNot(beTrue())
                expect(networkError?.code).toEventually(equal(400))
            }
        }
        
        context("create conversation and join") {
            it("should pass") {
                BasicOperations.login(with: self.client)
                
                let model = ConversationController.CreateConversation(name: "CON-new-test")
                var conversation: Conversation?

                do {
                    conversation = try self.client.conversation.new(model, withJoin: true).toBlocking().first()
                } catch let error {
                    fail(error.localizedDescription)
                }

                expect(conversation?.members.isEmpty).toEventuallyNot(beTrue(), timeout: 5, pollInterval: 1)
            }
            
            it("should fail when malformed JSON is returned by server") {
                let token = TokenBuilder(response: .createGetInfoConversations).post.build
                
                BasicOperations.login(with: self.client, using: token)
                
                let model = ConversationController.CreateConversation(name: "CON-new-test")
                var responseError: Error?
                
                _ = self.client.conversation.new(model, withJoin: true).subscribe(onError: { error in
                    responseError = error
                })
                
                expect(responseError).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
            }
        }
    }
}
