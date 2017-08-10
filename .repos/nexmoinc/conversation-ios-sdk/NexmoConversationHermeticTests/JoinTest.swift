//
//  JoinTest.swift
//  NexmoConversation
//
//  Created by Ivan on 17/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import NexmoConversation

class JoinTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    let client = ConversationClient.instance
    
    override func spec() {
        
        beforeEach {
            
        }
        
        afterEach {
            BasicOperations.logout(client: self.client)
        }
        
        context("join") {
            it("should pass") {
                BasicOperations.login(with: self.client)
                
                let model = ConversationController.JoinConversation(userId: TestConstants.User.uuid, memberId: TestConstants.Member.uuid)
                
                var statusResponse: MemberModel.State?
                
                _ = self.client.conversation.join(model, forUUID: TestConstants.Conversation.uuid)
                    .subscribe(onNext: { status in
                        statusResponse = status
                    }, onError: { _ in
                        fail()
                    })
                
                expect(statusResponse?.hashValue).toEventually(equal(MemberModel.State.joined.hashValue), timeout: 5, pollInterval: 1)
            }
            
            it("should fail when user is not logged in") {
                let model = ConversationController.JoinConversation(userId: TestConstants.User.uuid, memberId: TestConstants.Member.uuid)
                
                var responseError: Error?
                
                self.client.addAuthorization(with: "")
                _ = self.client.conversation.join(model, forUUID: TestConstants.Conversation.uuid)
                    .subscribe(onError: { error in
                        responseError = error
                    })
                
                expect(responseError).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("should pass when member id is empty") {
                BasicOperations.login(with: self.client)
                
                let model = ConversationController.JoinConversation(userId: TestConstants.User.uuid, memberId: nil)
                
                var statusResponse: MemberModel.State?
                
                _ = self.client.conversation.join(model, forUUID: TestConstants.Conversation.uuid)
                    .subscribe(onNext: { status in
                        statusResponse = status
                    }, onError: { _ in
                        fail()
                    })
                
                expect(statusResponse?.rawValue).toEventually(equal(MemberModel.State.joined.rawValue), timeout: 5, pollInterval: 1)
            }
            
            it("should fail when user has already joined conversation") {
                guard let token = ["template": "member-already-joined",
                                   "change_state_getinfo_members": 400].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                var responseError: Error?
                
                expect(self.client.conversation.conversations.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                let conversation = self.client.conversation.conversations.first
                
                expect(conversation?.state).toEventually(equal(MemberModel.State.joined), timeout: 5, pollInterval: 1)
                
                _ = conversation?.join().subscribe(onError: { error in
                    responseError = error
                })
                
                expect(responseError).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect((responseError as? NetworkError)?.localizedTitle).toEventually(equal(NetworkError.Code.Conversation.alreadyJoined.rawValue), timeout: 5, pollInterval: 1)
                expect((responseError as? NetworkError)?.localizedDescription).toEventually(equal("this user already has a member joined in 'app' type"), timeout: 5, pollInterval: 1)
            }
            
            it("should pass for retrieved conversation") {
                guard let token = ["state": ["getinfo_setinfo_delete_conversation":
                                    [MemberModel.State.invited.rawValue.capitalized,
                                     MemberModel.State.joined.rawValue.capitalized],
                                             "change_state_getinfo_members":
                                                MemberModel.State.joined.rawValue.capitalized],
                                   "wait": ["session:success": "3"]].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                var responseStatus: Bool?
                
                expect(self.client.conversation.conversations.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                expect(conversation).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(conversation.state).toEventually(equal(MemberModel.State.invited), timeout: 5, pollInterval: 1)
                
                _ = conversation.join().subscribe(onNext: {
                    responseStatus = true
                })
                
                expect(responseStatus).toEventually(beTrue(), timeout: 5, pollInterval: 1)
                expect(conversation.state).toEventually(equal(MemberModel.State.joined), timeout: 5, pollInterval: 1)
            }
            
            it("should pass for received invitation") {
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
                
                _ = conversation.join().subscribe(onNext: {
                    responseStatus = true
                })
                
                expect(responseStatus).toEventually(beTrue(), timeout: 5, pollInterval: 1)
                expect(conversation.state).toEventually(equal(MemberModel.State.joined), timeout: 5, pollInterval: 1)
            }
        }
        
        context("receive join") {
            it("should pass for self") {
                guard let token = ["template": ["session:success": "default,login-joined",
                                                "get_user_conversation_list": "conversation-list-empty"],
                                   "userid_joined": TestConstants.User.uuid,
                                   "memberid_joined": TestConstants.Member.uuid,
                                   "username_joined": TestConstants.User.name,
                                   "wait": ["session:success": "4"]].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                expect(self.client.conversation.conversations.count).to(equal(1))
                expect(self.client.conversation.conversations.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                expect(conversation).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(conversation.state).toEventually(equal(MemberModel.State.joined), timeout: 5, pollInterval: 1)
            }
            
            it("should pass for peer member") {
                guard let token = ["template": ["session:success": "default,login-joined",
                                                "getinfo_setinfo_delete_conversation": "conversation-single-member",
                                                "send_getrange_events": "event-list-empty"],
                                   "userid_joined": TestConstants.PeerUser.uuid,
                                   "memberid_joined": TestConstants.PeerMember.uuid,
                                   "username_joined": TestConstants.PeerUser.name,
                                   "wait": ["session:success": "4"]].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                var joinedMember: Member?
                
                expect(self.client.conversation.conversations.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                expect(conversation.members.count).to(equal(1))
                
                conversation.memberJoined.addHandler { member in
                    joinedMember = member
                }
                
                expect(joinedMember).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(joinedMember?.uuid).toEventuallyNot(equal(TestConstants.PeerMember.uuid), timeout: 5, pollInterval: 1)
                expect(joinedMember?.user.uuid).toEventuallyNot(equal(TestConstants.PeerUser.uuid), timeout: 5, pollInterval: 1)
                expect(joinedMember?.user.name).toEventuallyNot(equal(TestConstants.PeerUser.name), timeout: 5, pollInterval: 1)
                expect(joinedMember?.state).toEventuallyNot(equal(.joined), timeout: 5, pollInterval: 1)
                expect(conversation.members.count).toEventually(equal(2), timeout: 5, pollInterval: 1)
            }
        }
    }
}
