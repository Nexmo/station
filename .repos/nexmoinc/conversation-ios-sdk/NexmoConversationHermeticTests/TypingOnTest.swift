//
//  TypingOnTest.swift
//  NexmoConversation
//
//  Created by Ivan on 17/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import XCTest
import Quick
import Nimble
import NexmoConversation

class TypingOnTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    let client = ConversationClient.instance
    
    override func spec() {
        
        beforeEach {
            
        }
        
        afterEach {
            BasicOperations.logout(client: self.client)
        }
        
        context("send typing on") {
            it("should pass") {
                BasicOperations.login(with: self.client)
                
                let result = self.client.conversation.conversations.first?.startTyping()
                
                expect(result) == true
            }
            
            it("should fail when malformed JSON is returned by server") {
                let token = TokenBuilder(response: .sendGetRangeEvents).post.build
                
                BasicOperations.login(with: self.client, using: token)
                
                let result = self.client.conversation.conversations.first?.startTyping()
                
                expect(result) == true
                expect(self.client.conversation.conversations.first?.members.first?.typing.value).toEventually(
                    beFalse(), timeout: 5, pollInterval: 1)
            }
            
            it("should change member typing status") {
                BasicOperations.login(with: self.client)
                
                expect(self.client.conversation.conversations.first?.members.first?.typing.value).to(beFalse())
                    
                let result = self.client.conversation.conversations.first?.startTyping()
                    
                expect(result) == true
                expect(self.client.conversation.conversations.first?.members.first?.typing.value).toEventually(
                    beTrue(), timeout: 5, pollInterval: 1)
            }
            
            it("should not update member typing status for unknown conversation") {
                guard let token = ["template": "typing_on_specific",
                                   "cid": ["text:typing:on": "UNKNOWN-CID"]].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                let result = self.client.conversation.conversations.first?.startTyping()
                
                expect(result) == true
                expect(self.client.conversation.conversations.first?.members.first?.typing.value).toEventually(
                    beFalse(), timeout: 5, pollInterval: 1)
            }
            
            it("should not update member typing status for unknown member") {
                guard let token = ["template": "typing_on_specific",
                                   "from": ["text:typing:on": "UNKNOWN-MEM"]].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                let result = self.client.conversation.conversations.first?.startTyping()
                
                expect(result) == true
                expect(self.client.conversation.conversations.first?.members.first?.typing.value).toEventually(
                    beFalse(), timeout: 5, pollInterval: 1)
            }
            
            it("should not change conversations order for multiple conversations") {
                guard let token = ["template": ["get_user_conversation_list": "conversation-list-multi-known-cid",
                                                "getinfo_setinfo_delete_conversation": "conversation-random-member",
                                                "send_getrange_events": "event-list-empty"]].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                expect(self.client.conversation.conversations.count).toEventually(equal(3), timeout: 5, pollInterval: 1)
                
                expect(self.client.conversation.conversations[0].uuid).toEventuallyNot(equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
                expect(self.client.conversation.conversations[2].uuid).toEventually(equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
                
                let result = self.client.conversation.conversations[2].startTyping()
                
                expect(result) == true
                
                expect(self.client.conversation.conversations[0].uuid).toEventuallyNot(equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
                expect(self.client.conversation.conversations[2].uuid).toEventually(equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
            }
        }
        
        context("receive typing on") {
            it("should pass for own member") {
                guard let token = ["template": ["session:success": "default,typing_on"],
                                   "from": ["session:success": TestConstants.Member.uuid],
                                   "wait": ["session:success": 3]].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                expect(self.client.conversation.conversations.first?.members.first?.typing.value).toEventually(
                    beTrue(), timeout: 5, pollInterval: 1)
            }
            
            it("should pass for another member") {
                guard let token = ["template": ["session:success": "default,typing_on"],
                                   "from": ["session:success": TestConstants.PeerMember.uuid],
                                   "wait": ["session:success": 3]].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                expect(self.client.conversation.conversations.first?.members[1].typing.value).toEventually(
                    beTrue(), timeout: 5, pollInterval: 1)
            }
            
            it("should not update member typing status for unknown conversation") {
                guard let token = ["template": ["session:success": "default,typing_on"],
                                   "cid": ["session:success": "UNKNOWN-CID"],
                                   "wait": ["session:success": 3]].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                expect(self.client.conversation.conversations.first?.members.first?.typing.value).toEventually(
                    beFalse(), timeout: 5, pollInterval: 1)
            }
            
            it("should not update member typing status for unknown member") {
                guard let token = ["template": ["session:success": "default,typing_on"],
                                   "from": ["session:success": "UNKNOWN-MEM"],
                                   "wait": ["session:success": 3]].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                expect(self.client.conversation.conversations.first?.members.first?.typing.value).toEventually(
                    beFalse(), timeout: 5, pollInterval: 1)
            }
            
            it("should not change conversations order for multiple conversations") {
                guard let token = ["template": ["session:success": "default,typing_on",
                                                "get_user_conversation_list": "conversation-list-multi-known-cid",
                                                "getinfo_setinfo_delete_conversation": "conversation-random-members",
                                                "send_getrange_events": "event-list-empty"],
                                                "from": ["session:success": TestConstants.PeerMember.uuid],
                                                "wait": ["session:success": 3]].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                expect(self.client.conversation.conversations.count).toEventually(equal(3), timeout: 5, pollInterval: 1)
                
                expect(self.client.conversation.conversations[0].uuid).toEventuallyNot(equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
                expect(self.client.conversation.conversations[2].uuid).toEventually(equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
                
                expect(self.client.conversation.conversations[2].members.first?.typing.value).toEventually(beTrue(), timeout: 5, pollInterval: 1)
                
                expect(self.client.conversation.conversations[0].uuid).toEventuallyNot(equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
                expect(self.client.conversation.conversations[2].uuid).toEventually(equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
            }
        }
    }
}
