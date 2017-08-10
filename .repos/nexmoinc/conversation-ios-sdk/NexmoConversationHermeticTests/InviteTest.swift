//
//  InviteTest.swift
//  NexmoConversation
//
//  Created by Ivan on 17/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import XCTest
import Quick
import Nimble
import RxSwift
import RxTest
import RxBlocking
@testable import NexmoConversation

class InviteTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    let client = ConversationClient.instance
    
    override func spec() {
        
        beforeEach {
            
        }
        
        afterEach {
            BasicOperations.logout(client: self.client)
        }
        
        context("invite") {
            it("should pass") {
                BasicOperations.login(with: self.client)
                
                var statusResponse: Bool?
                
                _ = self.client.membershipController.invite(user: TestConstants.User.uuid, for: TestConstants.Conversation.uuid)
                    .subscribe(onNext: { statusResponse = true })
                
                expect(statusResponse).toEventually(beTrue(), timeout: 5, pollInterval: 1)
            }
            
            it("should fail when user is not logged in") {
                var responseError: Error?
                
                self.client.addAuthorization(with: "")
                _ = self.client.membershipController.invite(user: TestConstants.User.uuid, for: TestConstants.Conversation.uuid).subscribe(onError: { error in
                    responseError = error
                })
                
                expect(responseError).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("should pass from retrieved conversation") {
                BasicOperations.login(with: self.client)

                var responseStatus: Bool?
                let conversation = self.client.conversation.conversations.first

                _ = conversation?.invite(TestConstants.User.uuid).subscribe(onSuccess: {
                    responseStatus = true
                }, onError: { error in
                    fail()
                })
                
                expect(responseStatus).toEventually(beTrue(), timeout: 5, pollInterval: 1)
            }
        }
        
        context("receive invitation") {
            it("should pass") {
                guard let token = ["template": ["session:success": "default,invited",
                                                "get_user_conversation_list": "conversation-list-empty"],
                                   "state": MemberModel.State.invited.rawValue.capitalized,
                                   "cid": "CON-sdk-test-invited",
                                   "peer_user_id": TestConstants.User.uuid,
                                   "peer_member_id": TestConstants.Member.uuid,
                                   "peer_user_name": TestConstants.User.name,
                                   "wait": ["session:success": "3"]].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                expect(self.client.conversation.conversations.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                expect(conversation).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(conversation.state).toEventually(equal(MemberModel.State.invited), timeout: 5, pollInterval: 1)
            }
            
            it("should pass when user accepts it") {
                guard let token = ["template": ["session:success": "default,invited",
                                                "get_user_conversation_list": "conversation-list-empty"],
                                   "state": ["getinfo_setinfo_delete_conversation":
                                                [MemberModel.State.invited.rawValue.capitalized,
                                                 MemberModel.State.joined.rawValue.capitalized],
                                             "change_state_getinfo_members":
                                                MemberModel.State.joined.rawValue.capitalized],
                                   "cid": "CON-sdk-test-invited",
                                   "peer_user_id": TestConstants.User.uuid,
                                   "peer_member_id": TestConstants.Member.uuid,
                                   "peer_user_name": TestConstants.User.name,
                                   "wait": ["session:success": "3"]].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                var responseStatus: Bool?
                
                expect(self.client.conversation.conversations.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                expect(conversation).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(conversation.state).toEventually(equal(MemberModel.State.invited), timeout: 5, pollInterval: 1)
                
                _ = conversation.join().subscribe(onSuccess: {
                    responseStatus = true
                })

                expect(responseStatus).toEventually(beTrue(), timeout: 5, pollInterval: 1)
                expect(conversation.state).toEventually(equal(MemberModel.State.joined), timeout: 5, pollInterval: 1)
                expect(conversation.members.filter({ $0.state == .joined }).count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                expect(conversation.members.filter({ $0.state == .joined }).first?.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
            }
            
            it("should pass when user rejects it") {
                guard let token = ["template": "default,invited,conversation-list-empty",
                                   "state": ["getinfo_setinfo_delete_conversation": MemberModel.State.invited.rawValue.capitalized,
                                             "change_state_getinfo_members": MemberModel.State.left.rawValue.capitalized],
                                   "cid": "CON-sdk-test-invited",
                                   "peer_user_id": TestConstants.User.uuid,
                                   "peer_member_id": TestConstants.Member.uuid,
                                   "peer_user_name": TestConstants.User.name,
                                   "wait": ["session:success": "3"]].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                var responseStatus: Bool?
                
                expect(self.client.conversation.conversations.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                expect(conversation).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(conversation.state).toEventually(equal(MemberModel.State.invited), timeout: 5, pollInterval: 1)
                
                _ = conversation.leave().subscribe(onSuccess: { _ in
                    responseStatus = true
                }, onError: { _ in
                    fail()
                })
                
                expect(responseStatus).toEventually(beTrue(), timeout: 5, pollInterval: 1)
                expect(conversation.state).toEventually(equal(MemberModel.State.left), timeout: 5, pollInterval: 1)
            }
        }
    }
}
