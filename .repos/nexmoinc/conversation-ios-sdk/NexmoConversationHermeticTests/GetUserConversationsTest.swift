//
//  GetUserConversationsTest.swift
//  NexmoConversation
//
//  Created by Ivan on 20/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import XCTest
import Quick
import Nimble
import NexmoConversation

class GetUserConversationsTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    let client = ConversationClient.instance
    
    override func spec() {
        
        beforeEach {
            
        }
        
        afterEach {
            BasicOperations.logout(client: self.client)
        }
        
        context("get conversations user is a member of") {
            it("should pass") {
                BasicOperations.login(with: self.client)
                
                var conversationResponse: [ConversationPreviewModel]?
                
                _ = self.client.conversation.all(with: TestConstants.User.uuid).subscribe(onNext: { conversation in
                    conversationResponse = conversation
                }, onError: { _ in
                    fail()
                })
                
                expect(conversationResponse?.count).toEventuallyNot(equal(0), timeout: 5, pollInterval: 1)
            }
            
            it("should fail when user is not logged in") {
                var responseError: Error?
                
                self.client.addAuthorization(with: "")
                _ = self.client.conversation.all(with: TestConstants.User.uuid).subscribe(onError: { error in
                    responseError = error
                })
                
                expect(responseError).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("should fail when malformed JSON is returned by server") {
                let token = TokenBuilder(response: .getUserConversationList).get.build
                
                BasicOperations.login(with: self.client, using: token, waitForSync: false)
                
                expect {
                    try self.client.conversation.all(with: TestConstants.User.uuid).toBlocking().first()
                }.to(throwError())
            }
            
            it("should pass if conversation list is empty") {
                guard let token = ["template": "conversation-list-empty"].JSONString else {
                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                var conversationResponse: [ConversationPreviewModel]?
                
                _ = self.client.conversation.all(with: TestConstants.User.uuid).subscribe(onNext: { conversation in
                    conversationResponse = conversation
                }, onError: { _ in
                    fail()
                })
                
                expect(conversationResponse?.count).toEventually(equal(0), timeout: 5, pollInterval: 1)
            }
            
            it("should pass for conversation in invited state") {
                guard let token = ["state": MemberModel.State.invited.rawValue.capitalized].JSONString else {
                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                var conversationResponse: [ConversationPreviewModel]?
                
                _ = self.client.conversation.all(with: TestConstants.User.uuid).subscribe(onNext: { conversation in
                    conversationResponse = conversation
                }, onError: { _ in
                    fail()
                })
                
                expect(conversationResponse?.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                
                guard let conversation = conversationResponse?.first else { return fail() }
                
                expect(conversation.uuid).toEventually(equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
                expect(conversation.memberId).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                expect(conversation.name).toEventually(equal(TestConstants.Conversation.name), timeout: 5, pollInterval: 1)
                expect(conversation.state).toEventually(equal(MemberModel.State.invited), timeout: 5, pollInterval: 1)
                expect(conversation.sequenceNumber).toEventually(equal(3), timeout: 5, pollInterval: 1)
            }
            
            it("should pass for conversation in joined state") {
                BasicOperations.login(with: self.client)
                
                var conversationResponse: [ConversationPreviewModel]?
                
                _ = self.client.conversation.all(with: TestConstants.User.uuid).subscribe(onNext: { conversation in
                    conversationResponse = conversation
                }, onError: { _ in
                    fail()
                })
                
                expect(conversationResponse?.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                
                guard let conversation = conversationResponse?.first else { return fail() }
                
                expect(conversation.uuid).toEventually(equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
                expect(conversation.memberId).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                expect(conversation.name).toEventually(equal(TestConstants.Conversation.name), timeout: 5, pollInterval: 1)
                expect(conversation.state).toEventually(equal(MemberModel.State.joined), timeout: 5, pollInterval: 1)
                expect(conversation.sequenceNumber).toEventually(equal(3), timeout: 5, pollInterval: 1)
            }
            
            it("should pass for conversation in left state") {
                guard let token = ["state": MemberModel.State.left.rawValue.capitalized].JSONString else {
                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                var conversationResponse: [ConversationPreviewModel]?
                
                _ = self.client.conversation.all(with: TestConstants.User.uuid).subscribe(onNext: { conversation in
                    conversationResponse = conversation
                }, onError: { _ in
                    fail()
                })
                
                expect(conversationResponse?.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                
                guard let conversation = conversationResponse?.first else { return fail() }
                
                expect(conversation.uuid).toEventually(equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
                expect(conversation.memberId).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                expect(conversation.name).toEventually(equal(TestConstants.Conversation.name), timeout: 5, pollInterval: 1)
                expect(conversation.state).toEventually(equal(MemberModel.State.left), timeout: 5, pollInterval: 1)
                expect(conversation.sequenceNumber).toEventually(equal(3), timeout: 5, pollInterval: 1)
            }
            
            it("should pass for multiple conversations") {
                guard let token = ["template": "conversation-list-multi"].JSONString else {
                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                var conversationResponse: [ConversationPreviewModel]?
                
                _ = self.client.conversation.all(with: TestConstants.User.uuid).subscribe(onNext: { conversation in
                    conversationResponse = conversation
                }, onError: { _ in
                    fail()
                })
                
                expect(conversationResponse?.count).toEventually(equal(3), timeout: 5, pollInterval: 1)
                
                conversationResponse?.forEach { conversation in
                    expect(conversation.uuid).toEventually(beginWith("CON-"), timeout: 5, pollInterval: 1)
                    expect(conversation.memberId).toEventually(beginWith("MEM-"), timeout: 5, pollInterval: 1)
                    expect(conversation.name).toEventually(equal(TestConstants.Conversation.name), timeout: 5, pollInterval: 1)
                    expect(conversation.state).toEventually(equal(MemberModel.State.joined), timeout: 5, pollInterval: 1)
                    expect(conversation.sequenceNumber).toEventually(equal(3), timeout: 5, pollInterval: 1)
                }
            }
            
            it("should pass on sync for empty conversation list") {
                guard let token = ["template": "conversation-list-empty"].JSONString else {
                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                expect(self.client.conversation.conversations.count).toEventually(equal(0), timeout: 5, pollInterval: 1)
            }
            
            it("should pass on sync for single conversation") {
                BasicOperations.login(with: self.client)
                
                expect(self.client.conversation.conversations.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                expect(self.client.conversation.conversations.first?.uuid).toEventually(
                    equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
            }
            
            it("should pass on sync for multiple conversations") {
                guard let token = ["template": "conversation-list-multi"].JSONString else {
                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                expect(self.client.conversation.conversations.count).toEventually(equal(3), timeout: 5, pollInterval: 1)
                self.client.conversation.conversations.forEach { conversation in
                    expect(conversation.uuid).toEventually(beginWith("CON-"), timeout: 5, pollInterval: 1)
                }
            }
        }
    }
}
