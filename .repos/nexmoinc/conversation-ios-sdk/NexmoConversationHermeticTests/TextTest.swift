//
//  TextTest.swift
//  NexmoConversation
//
//  Created by Ivan on 17/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import XCTest
import Quick
import Nimble
import NexmoConversation

class TextTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    let client = ConversationClient.instance
    
    override func spec() {
        
        beforeEach {
            
        }
        
        afterEach {
            BasicOperations.logout(client: self.client)
        }
        
        context("send text") {
            it("should pass") {
                guard let token = ["text_id": 4, "event_id": 4].JSONString else { return fail() }

                BasicOperations.login(with: self.client, using: token)
                
                var returnedEvent: TextEvent?
                
                let conversation = self.client.conversation.conversations.first
                
                conversation?.newEventReceived.addHandler { returnedEvent = $0 as? TextEvent }
                
                guard let _ = try? conversation?.send(TestConstants.Text.text) == nil else { return fail() }
                
                expect(returnedEvent?.text?.isEmpty).toEventually(beFalse(), timeout: 10)
            }
            
            it("should fail when malformed JSON is returned by server") {
                let token = TokenBuilder(response: .sendGetRangeEvents).post.build
                
                BasicOperations.login(with: self.client, using: token)
                
                var returnedEvent: EventBase?
                
                self.client.conversation.conversations.first?.messageSent.addHandler { event in
                    returnedEvent = event
                }
                
                _ = try? self.client.conversation.conversations.first?.send(TestConstants.Text.text)
                
                expect(returnedEvent).toEventually(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("should fail when text is empty") {
                BasicOperations.login(with: self.client)
                
                var returnedEvent: EventBase?
                
                self.client.conversation.conversations.first?.messageSent.addHandler { event in
                    returnedEvent = event
                }
                
                _ = try? self.client.conversation.conversations.first?.send("")
                
                expect(returnedEvent).toEventually(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("receipt should not be created") {
                guard let token = ["text_id": 4, "event_id": 4].JSONString else {
                    return fail()
                }
                BasicOperations.login(with: self.client, using: token)
                
                var returnedEvent: EventBase?
                
                let conversation = self.client.conversation.conversations.first
                
                conversation?.newEventReceived.addHandler {
                    returnedEvent = $0 as? TextEvent
                }
                
                _ = try? conversation?.send(TestConstants.Text.text)
                
                expect((returnedEvent as? TextEvent)?.allReceipts.count).toEventually(equal(0), timeout: 5, pollInterval: 1)
            }
            
            it("isCurrentlyBeingSent should be true") {
                guard let token = ["text_id": 4, "event_id": 4].JSONString else {
                    return fail()
                }

                BasicOperations.login(with: self.client, using: token)

                let conversation = self.client.conversation.conversations.first

                _ = try? conversation?.send(TestConstants.Text.text)

                expect(
                    conversation?.allEvents.contains(where: { ($0 as? TextEvent)?.isCurrentlyBeingSent == true }
                )).toEventually(beTrue(), timeout: 5, pollInterval: 1)
            }
            
            it("should pass for newly joined conversation") {
                guard let token = ["template": "default,invited,conversation-list-empty",
                                   "state": ["getinfo_setinfo_delete_conversation":
                                                [MemberModel.State.invited.rawValue.capitalized,
                                                 MemberModel.State.joined.rawValue.capitalized],
                                             "change_state_getinfo_members":
                                                MemberModel.State.joined.rawValue.capitalized],
                                   "cid": "CON-sdk-test-invited",
                                   "peer_user_id": TestConstants.User.uuid,
                                   "peer_member_id": TestConstants.Member.uuid,
                                   "peer_user_name": TestConstants.User.name,
                                   "text_id": 4,
                                   "event_id": 4,
                                   "wait": ["session:success": "3"]].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                var textSent: TextEvent?
                var responseStatus: Bool?
                
                expect(self.client.conversation.conversations.first).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                let conversation = self.client.conversation.conversations.first
                
                expect(conversation?.state).toEventually(equal(MemberModel.State.invited), timeout: 5, pollInterval: 1)

                _ = conversation?.join().subscribe(onSuccess: {
                    responseStatus = true
                })
                
                expect(responseStatus).toEventually(beTrue(), timeout: 5, pollInterval: 1)
                conversation?.newEventReceived.addHandler({ text in
                    textSent = text as? TextEvent
                })
                
                _ = try? conversation?.send(TestConstants.Text.text)
                
                expect(textSent).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(textSent?.text).toEventually(equal(TestConstants.Text.text), timeout: 5, pollInterval: 1)
            }
            
            it("should change conversations order for multiple conversations") {
                guard let token = ["template": ["get_user_conversation_list": "conversation-list-multi-known-cid",
                                                "getinfo_setinfo_delete_conversation": "conversation-random-member",
                                                "send_getrange_events": "event-list-empty"]].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                expect(self.client.conversation.conversations.count).toEventually(equal(3), timeout: 5, pollInterval: 1)
                
                expect(self.client.conversation.conversations[0].uuid).toEventuallyNot(equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
                expect(self.client.conversation.conversations[2].uuid).toEventually(equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
                
                _ = try? self.client.conversation.conversations[2].send(TestConstants.Text.text)
                
                expect(self.client.conversation.conversations[0].uuid).toEventually(equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
                expect(self.client.conversation.conversations[2].uuid).toEventuallyNot(equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
            }
        }
        
        context("receive text") {
            it("should pass") {
                // TODO: flaky when running in batch
                
                var responseText: TextEvent?
                
                guard let token = ["template": "default,text",
                                   "from": TestConstants.PeerMember.uuid,
                                   "text_event_id": TestConstants.Text.uuid,
                                   "wait": "4"].JSONString else {
                                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                self.client.conversation.conversations.first?.newEventReceived.addHandler { event in
                    responseText = event as? TextEvent
                }
                
                expect(self.client.conversation.conversations.first?.allEvents.count).toEventually(equal(5), timeout: 5, pollInterval: 1)
                expect(responseText).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(responseText?.fromMember.uuid).toEventually(equal(TestConstants.PeerMember.uuid), timeout: 5, pollInterval: 1)
                expect(responseText?.from.uuid).toEventually(equal(TestConstants.PeerUser.uuid), timeout: 5, pollInterval: 1)
            }
            
            it("receipt should be created") {
                guard let token = ["template": "default,text",
                                   "from": TestConstants.PeerMember.uuid,
                                   "text_event_id": 4,
                                   "wait": "3"].JSONString else {
                                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                var responseText: EventBase?
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                conversation.newEventReceived.addHandler { event in
                    responseText = event
                }
                
                expect(responseText).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect((responseText as? TextEvent)?.allReceipts.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
            }
            
            it("should change conversations order for multiple conversations") {
                guard let token = ["template": ["session:success": "default,text",
                                                "get_user_conversation_list": "conversation-list-multi-known-cid",
                                                "send_getrange_events": "event-list-empty"],
                                   "from": TestConstants.PeerMember.uuid,
                                   "image_event_id": 5,
                                   "wait": "3"].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                expect(self.client.conversation.conversations.count).toEventually(equal(3), timeout: 5, pollInterval: 1)
                
                expect(self.client.conversation.conversations[0].uuid).toEventuallyNot(equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
                expect(self.client.conversation.conversations[2].uuid).toEventually(equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
                
                expect(self.client.conversation.conversations[2].allEvents.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                
                expect(self.client.conversation.conversations[0].uuid).toEventually(equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
                expect(self.client.conversation.conversations[2].uuid).toEventuallyNot(equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
            }
        }
    }
}
