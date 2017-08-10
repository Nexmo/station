//
//  KickTest.swift
//  NexmoConversation
//
//  Created by Ivan on 17/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import XCTest
import Quick
import Nimble
import NexmoConversation

class KickTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    let client = ConversationClient.instance
    
    override func spec() {
        
        beforeEach {

        }
        
        afterEach {
            BasicOperations.logout(client: self.client)
        }
        
        context("issue kick") {
            it("should pass for peer member") {
                BasicOperations.login(with: self.client)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                let peerMember = conversation.members[1]
                
                var responseStatus: Bool?
                
                _ = peerMember.kick().subscribe(onSuccess: { _ in
                    responseStatus = true
                }, onError: { _ in
                    fail()
                })
                
                expect(responseStatus).toEventually(beTrue(), timeout: 5, pollInterval: 1)
            }
            
            it("should pass for self") {
                BasicOperations.login(with: self.client)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                guard let selfMember = conversation.members.first else { return fail() }
                
                var responseStatus: Bool?
                
                _ = selfMember.kick().subscribe(onSuccess: { _ in
                    responseStatus = true
                }, onError: { _ in
                    fail()
                })
                
                expect(responseStatus).toEventually(beTrue(), timeout: 5, pollInterval: 1)
            }
        }
        
        context("receive kick") {
            it("should pass for self") {
                guard let token = ["template": "default,left",
                                   "user_name_left": TestConstants.User.name,
                                   "user_id_left": TestConstants.User.uuid,
                                   "member_id_left": TestConstants.Member.uuid,
                                   "cid_left": TestConstants.Conversation.uuid,
                                   "wait": 4].JSONString else { return fail() }
                
                var memberLeft: Member?
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                conversation.memberLeft.addHandler { member in memberLeft = member }
                
                expect(memberLeft?.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                expect(memberLeft?.state).toEventually(equal(.left), timeout: 5, pollInterval: 1)
                expect(memberLeft?.user.name).toEventually(equal(TestConstants.User.name), timeout: 5, pollInterval: 1)
                expect(memberLeft?.user.uuid).toEventually(equal(TestConstants.User.uuid), timeout: 5, pollInterval: 1)
                expect(memberLeft?.conversation.uuid).toEventually(equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
                expect(memberLeft?.conversation.name).toEventually(equal(TestConstants.Conversation.name), timeout: 5, pollInterval: 1)
                expect(memberLeft?.conversation.state).toEventually(equal(.left), timeout: 5, pollInterval: 1)
                expect(memberLeft?.conversation.creationDate).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(memberLeft?.conversation.members.count).toEventually(equal(2), timeout: 5, pollInterval: 1)
                expect(memberLeft?.conversation.members[0].state).toEventually(equal(.left), timeout: 5, pollInterval: 1)
            }
            
            it("should pass for peer member") {
                guard let token = ["template": "default,left",
                                   "user_name_left": TestConstants.PeerUser.name,
                                   "user_id_left": TestConstants.PeerUser.uuid,
                                   "member_id_left": TestConstants.PeerMember.uuid,
                                   "cid_left": TestConstants.Conversation.uuid,
                                   "wait": 4].JSONString else { return fail() }
                
                var memberLeft: Member?
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                conversation.memberLeft.addHandler { member in memberLeft = member }
                
                expect(memberLeft?.uuid).toEventually(equal(TestConstants.PeerMember.uuid), timeout: 5, pollInterval: 1)
                expect(memberLeft?.state).toEventually(equal(.left), timeout: 5, pollInterval: 1)
                expect(memberLeft?.user.name).toEventually(equal(TestConstants.PeerUser.name), timeout: 5, pollInterval: 1)
                expect(memberLeft?.user.uuid).toEventually(equal(TestConstants.PeerUser.uuid), timeout: 5, pollInterval: 1)
                expect(memberLeft?.conversation.uuid).toEventually(equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
                expect(memberLeft?.conversation.name).toEventually(equal(TestConstants.Conversation.name), timeout: 5, pollInterval: 1)
                expect(memberLeft?.conversation.state).toEventually(equal(.left), timeout: 5, pollInterval: 1)
                expect(memberLeft?.conversation.creationDate).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(memberLeft?.conversation.members.count).toEventually(equal(2), timeout: 5, pollInterval: 1)
                expect(memberLeft?.conversation.members[1].state).toEventually(equal(.left), timeout: 5, pollInterval: 1)
            }
            
            it("should fail for unknown member") {
                guard let token = ["template": "default,left",
                                   "user_name_left": "UNKNOWN-NAME",
                                   "user_id_left": "UNKNOWN-USER-ID",
                                   "member_id_left": "UNKNOWN-MEMBER",
                                   "cid_left": TestConstants.Conversation.uuid,
                                   "wait": 4].JSONString else { return fail() }
                
                var memberLeft: Member?
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                conversation.memberLeft.addHandler { member in memberLeft = member }
                
                expect(memberLeft).toEventually(beNil(), timeout: 5, pollInterval: 1)
                expect(conversation.members.count).toEventually(equal(2), timeout: 5, pollInterval: 1)
                expect(conversation.state).toEventually(equal(MemberModel.State.joined), timeout: 5, pollInterval: 1)
                expect(conversation.members[0].state).toEventually(equal(MemberModel.State.joined), timeout: 5, pollInterval: 1)
                expect(conversation.members[1].state).toEventually(equal(MemberModel.State.joined), timeout: 5, pollInterval: 1)
            }
        }
        
        context("leave") {
            it("should pass") {
                BasicOperations.login(with: self.client)
                
                var responseStatus: Bool?
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
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
