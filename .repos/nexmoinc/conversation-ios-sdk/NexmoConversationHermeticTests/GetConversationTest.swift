//
//  GetConversationTest.swift
//  NexmoConversation
//
//  Created by Ivan on 20/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import XCTest
import Quick
import Nimble
import NexmoConversation

class GetConversationTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    let client = ConversationClient.instance

    override func spec() {
        
        beforeEach {
            
        }
        
        afterEach {
            BasicOperations.logout(client: self.client)
        }
        
        context("get conversation details") {
            it("should pass") {
                BasicOperations.login(with: self.client)
                
                var conversationResponse: Conversation?
                
                _ = self.client.conversation.conversation(with: TestConstants.Conversation.uuid).subscribe(onNext: { conversation in
                    conversationResponse = conversation
                }, onError: { _ in
                    fail()
                })
                
                expect(conversationResponse?.name).toEventually(equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
            }

            it("should fail when user is not logged in") {
                var responseError: Error?
                
                self.client.addAuthorization(with: "")
                _ = self.client.conversation.conversation(with: TestConstants.Conversation.uuid).subscribe(onError: { error in
                    responseError = error
                })
                
                expect(responseError).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("should fail when malformed JSON is returned by server") {
                let token = TokenBuilder(response: .getInfoSetInfoDeleteConversation).get.build

                BasicOperations.login(with: self.client, using: token, waitForSync: false)

                expect {
                    try self.client.conversation.conversation(with: TestConstants.Conversation.uuid).toBlocking().first()
                }.to(throwError())

                expect(self.client.state.value) == ConversationClient.State.outOfSync
            }
            
            it("members should be retrieved with the conversation") {
                BasicOperations.login(with: self.client)
                
                var conversation: Conversation?

                do {
                    conversation = try self.client.conversation.conversation(with: TestConstants.Conversation.uuid)
                        .toBlocking()
                        .first()
                } catch let error {
                    fail(error.localizedDescription)
                }

                expect(conversation?.members).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(conversation?.members.count).toEventuallyNot(equal(0), timeout: 5, pollInterval: 1)
            }
            
            it("should pass on sync for a conversation in joined state") {
                BasicOperations.login(with: self.client)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                expect(conversation.members.count).toEventually(equal(2), timeout: 5, pollInterval: 1)
                expect(conversation.members.filter({ $0.state == .joined }).count).toEventually(equal(2), timeout: 5, pollInterval: 1)
                expect(conversation.state).toEventually(equal(MemberModel.State.joined), timeout: 5, pollInterval: 1)
                expect(conversation.creationDate).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(conversation.lastSequence).toEventually(equal(3), timeout: 5, pollInterval: 1)
                expect(conversation.users.count).toEventually(equal(2), timeout: 5, pollInterval: 1)
                
                expect(conversation.members.first?.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                expect(conversation.members.first?.state).toEventually(equal(MemberModel.State.joined), timeout: 5, pollInterval: 1)
                expect(conversation.members.first?.user.name).toEventually(equal(TestConstants.User.name), timeout: 5, pollInterval: 1)
                expect(conversation.members.first?.user.uuid).toEventually(equal(TestConstants.User.uuid), timeout: 5, pollInterval: 1)
                expect(conversation.members.first?.user.isMe).toEventually(beTrue(), timeout: 5, pollInterval: 1)
                
                expect(conversation.members[1].uuid).toEventually(equal(TestConstants.PeerMember.uuid), timeout: 5, pollInterval: 1)
                expect(conversation.members[1].state).toEventually(equal(MemberModel.State.joined), timeout: 5, pollInterval: 1)
                expect(conversation.members[1].user.name).toEventually(equal(TestConstants.PeerUser.name), timeout: 5, pollInterval: 1)
                expect(conversation.members[1].user.uuid).toEventually(equal(TestConstants.PeerUser.uuid), timeout: 5, pollInterval: 1)
                expect(conversation.members[1].user.isMe).toEventually(beFalse(), timeout: 5, pollInterval: 1)
            }
            
            it("should pass on sync for a conversation in invited state") {
                guard let token = ["state": MemberModel.State.invited.rawValue.capitalized].JSONString else {
                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                expect(conversation.members.count).toEventually(equal(2), timeout: 5, pollInterval: 1)
                expect(conversation.members.filter({ $0.state == .joined }).count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                expect(conversation.state).toEventually(equal(MemberModel.State.invited), timeout: 5, pollInterval: 1)
                expect(conversation.creationDate).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(conversation.lastSequence).toEventually(equal(3), timeout: 5, pollInterval: 1)
                expect(conversation.users.count).toEventually(equal(2), timeout: 5, pollInterval: 1)
                
                expect(conversation.members.first?.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                expect(conversation.members.first?.state).toEventually(equal(MemberModel.State.invited), timeout: 5, pollInterval: 1)
                expect(conversation.members.first?.user.name).toEventually(equal(TestConstants.User.name), timeout: 5, pollInterval: 1)
                expect(conversation.members.first?.user.uuid).toEventually(equal(TestConstants.User.uuid), timeout: 5, pollInterval: 1)
                expect(conversation.members.first?.user.isMe).toEventually(beTrue(), timeout: 5, pollInterval: 1)
                
                expect(conversation.members[1].uuid).toEventually(equal(TestConstants.PeerMember.uuid), timeout: 5, pollInterval: 1)
                expect(conversation.members[1].state).toEventually(equal(MemberModel.State.invited), timeout: 5, pollInterval: 1)
                expect(conversation.members[1].user.name).toEventually(equal(TestConstants.PeerUser.name), timeout: 5, pollInterval: 1)
                expect(conversation.members[1].user.uuid).toEventually(equal(TestConstants.PeerUser.uuid), timeout: 5, pollInterval: 1)
                expect(conversation.members[1].user.isMe).toEventually(beFalse(), timeout: 5, pollInterval: 1)
            }
            
            it("should pass on sync for a conversation in left state") {
                guard let token = ["state": MemberModel.State.left.rawValue.capitalized].JSONString else {
                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                expect(conversation.members.count).toEventually(equal(2), timeout: 5, pollInterval: 1)
                expect(conversation.members.filter({ $0.state == .joined }).count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                expect(conversation.state).toEventually(equal(MemberModel.State.left), timeout: 5, pollInterval: 1)
                expect(conversation.creationDate).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(conversation.lastSequence).toEventually(equal(3), timeout: 5, pollInterval: 1)
                expect(conversation.users.count).toEventually(equal(2), timeout: 5, pollInterval: 1)
                
                expect(conversation.members.first?.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                expect(conversation.members.first?.state).toEventually(equal(MemberModel.State.left), timeout: 5, pollInterval: 1)
                expect(conversation.members.first?.user.name).toEventually(equal(TestConstants.User.name), timeout: 5, pollInterval: 1)
                expect(conversation.members.first?.user.uuid).toEventually(equal(TestConstants.User.uuid), timeout: 5, pollInterval: 1)
                expect(conversation.members.first?.user.isMe).toEventually(beTrue(), timeout: 5, pollInterval: 1)
                
                expect(conversation.members[1].uuid).toEventually(equal(TestConstants.PeerMember.uuid), timeout: 5, pollInterval: 1)
                expect(conversation.members[1].state).toEventually(equal(MemberModel.State.left), timeout: 5, pollInterval: 1)
                expect(conversation.members[1].user.name).toEventually(equal(TestConstants.PeerUser.name), timeout: 5, pollInterval: 1)
                expect(conversation.members[1].user.uuid).toEventually(equal(TestConstants.PeerUser.uuid), timeout: 5, pollInterval: 1)
                expect(conversation.members[1].user.isMe).toEventually(beFalse(), timeout: 5, pollInterval: 1)
            }
            
            it("should pass on sync for a conversation with a single member") {
                guard let token = ["template": ["getinfo_setinfo_delete_conversation": "conversation-single-member",
                                                "send_getrange_events": "event-list-empty"]].JSONString else {
                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                expect(conversation.members.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                expect(conversation.members.filter({ $0.state == .joined }).count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                expect(conversation.state).toEventually(equal(MemberModel.State.joined), timeout: 5, pollInterval: 1)
                expect(conversation.creationDate).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(conversation.lastSequence).toEventually(equal(3), timeout: 5, pollInterval: 1)
                expect(conversation.users.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                
                expect(conversation.members.first?.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                expect(conversation.members.first?.state).toEventually(equal(MemberModel.State.joined), timeout: 5, pollInterval: 1)
                expect(conversation.members.first?.user.name).toEventually(equal(TestConstants.User.name), timeout: 5, pollInterval: 1)
                expect(conversation.members.first?.user.uuid).toEventually(equal(TestConstants.User.uuid), timeout: 5, pollInterval: 1)
                expect(conversation.members.first?.user.isMe).toEventually(beTrue(), timeout: 5, pollInterval: 1)
            }
            
            it("should pass on sync for multiple conversations with same member id") {
                guard let token = ["template": ["get_user_conversation_list": "conversation-list-multi",
                                                "send_getrange_events": "event-list-empty"]].JSONString else {
                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                expect(self.client.conversation.conversations.count).toEventually(equal(3), timeout: 5, pollInterval: 1)
                
                self.client.conversation.conversations.forEach { conversation in
                    expect(conversation.members.count).toEventually(equal(2), timeout: 5, pollInterval: 1)
                    expect(conversation.members.filter({ $0.state == .joined }).count).toEventually(equal(2), timeout: 5, pollInterval: 1)
                    expect(conversation.state).toEventually(equal(MemberModel.State.joined), timeout: 5, pollInterval: 1)
                    expect(conversation.creationDate).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                    expect(conversation.lastSequence).toEventually(equal(3), timeout: 5, pollInterval: 1)
                    expect(conversation.users.count).toEventually(equal(2), timeout: 5, pollInterval: 1)
                    
                    expect(conversation.members.first?.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                    expect(conversation.members.first?.state).toEventually(equal(MemberModel.State.joined), timeout: 5, pollInterval: 1)
                    expect(conversation.members.first?.user.name).toEventually(equal(TestConstants.User.name), timeout: 5, pollInterval: 1)
                    expect(conversation.members.first?.user.uuid).toEventually(equal(TestConstants.User.uuid), timeout: 5, pollInterval: 1)
                    expect(conversation.members.first?.user.isMe).toEventually(beTrue(), timeout: 5, pollInterval: 1)
                    
                    expect(conversation.members[1].uuid).toEventually(equal(TestConstants.PeerMember.uuid), timeout: 5, pollInterval: 1)
                    expect(conversation.members[1].state).toEventually(equal(MemberModel.State.joined), timeout: 5, pollInterval: 1)
                    expect(conversation.members[1].user.name).toEventually(equal(TestConstants.PeerUser.name), timeout: 5, pollInterval: 1)
                    expect(conversation.members[1].user.uuid).toEventually(equal(TestConstants.PeerUser.uuid), timeout: 5, pollInterval: 1)
                    expect(conversation.members[1].user.isMe).toEventually(beFalse(), timeout: 5, pollInterval: 1)
                }
            }
            
            it("should pass on sync for multiple conversations with different member id") {
                guard let token = ["template": ["get_user_conversation_list": "conversation-list-multi",
                                                "send_getrange_events": "event-list-empty",
                                                "getinfo_setinfo_delete_conversation": "conversation-random-member"]].JSONString else {
                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                expect(self.client.conversation.conversations.count).toEventually(equal(3), timeout: 5, pollInterval: 1)
                
                self.client.conversation.conversations.forEach { conversation in
                    expect(conversation.members.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                    expect(conversation.members.filter({ $0.state == .joined }).count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                    expect(conversation.state).toEventually(equal(MemberModel.State.joined), timeout: 5, pollInterval: 1)
                    expect(conversation.creationDate).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                    expect(conversation.lastSequence).toEventually(equal(3), timeout: 5, pollInterval: 1)
                    expect(conversation.users.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                    
                    expect(conversation.members.first?.uuid).toEventually(beginWith("MEM-"), timeout: 5, pollInterval: 1)
                    expect(conversation.members.first?.state).toEventually(equal(MemberModel.State.joined), timeout: 5, pollInterval: 1)
                    expect(conversation.members.first?.user.name).toEventually(equal(TestConstants.User.name), timeout: 5, pollInterval: 1)
                    expect(conversation.members.first?.user.uuid).toEventually(equal(TestConstants.User.uuid), timeout: 5, pollInterval: 1)
                    expect(conversation.members.first?.user.isMe).toEventually(beTrue(), timeout: 5, pollInterval: 1)
                }
            }
        }
    }
}
