//
//  ImageTest.swift
//  NexmoConversation
//
//  Created by Ivan on 17/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import XCTest
import Quick
import Nimble
import NexmoConversation

class ImageTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    let client = ConversationClient.instance
    
    override func spec() {
        
        beforeEach {
            
        }
        
        afterEach {
            BasicOperations.logout(client: self.client)
        }
        
        context("send image") {
            it("should pass") {
                // login
                BasicOperations.login(with: self.client)
                
                var returnedEvent: EventBase?
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                // listen for new events
                conversation.newEventReceived.addHandler { event in
                    returnedEvent = event
                }
                
                // create event with image
                guard let image = UIImage(named: AssetsTest.nexmo.path, in: Bundle(for: type(of: self)), compatibleWith: nil) else { return fail() }
                guard let data = UIImageJPEGRepresentation(image, 0.75) else { return fail() }
                
                // send event
                _ = try? conversation.send(data)
                
                // test
                expect((returnedEvent as? ImageEvent)?.image).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect((returnedEvent as? ImageEvent)?.fromMember.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
            }
            
            it("should fail when malformed JSON is returned by server") {
                let token = TokenBuilder(response: .sendGetRangeEvents).post.build

                BasicOperations.login(with: self.client, using: token)
                
                var returnedEvent: EventBase?
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                // listen for new events
                conversation.newEventReceived.addHandler { event in
                    returnedEvent = event
                }
                
                guard let image = UIImage(named: AssetsTest.nexmo.path, in: Bundle(for: type(of: self)), compatibleWith: nil) else { return fail() }
                guard let data = UIImageJPEGRepresentation(image, 0.75) else { return fail() }
                
                _ = try? conversation.send(data)
                
                expect(returnedEvent?.uuid.characters.count).toEventuallyNot(beGreaterThan(4), timeout: 15, pollInterval: 1)
            }
            
            it("receipt should not be created") {
                BasicOperations.login(with: self.client)
                
                var returnedEvent: EventBase?
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                conversation.newEventReceived.addHandler { event in
                    returnedEvent = event
                }
                
                guard let image = UIImage(named: AssetsTest.nexmo.path, in: Bundle(for: type(of: self)), compatibleWith: nil) else { return fail() }
                guard let data = UIImageJPEGRepresentation(image, 0.75) else { return fail() }
                
                _ = try? conversation.send(data)
                
                expect((returnedEvent as? ImageEvent)?.allReceipts.count).toEventually(equal(0), timeout: 5, pollInterval: 1)
            }
            
            it("should change conversations order for multiple conversations") {
                guard let token = ["template": ["get_user_conversation_list": "conversation-list-multi-known-cid",
                                                "getinfo_setinfo_delete_conversation": "conversation-random-member",
                                                "send_getrange_events": "event-list-empty"]].JSONString else {
                                                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                expect(self.client.conversation.conversations.count).toEventually(equal(3), timeout: 5, pollInterval: 1)
                
                expect(self.client.conversation.conversations[0].uuid).toEventuallyNot(equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
                expect(self.client.conversation.conversations[2].uuid).toEventually(equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
                
                guard let image = UIImage(named: AssetsTest.nexmo.path, in: Bundle(for: type(of: self)), compatibleWith: nil) else { return fail() }
                guard let data = UIImageJPEGRepresentation(image, 0.75) else { return fail() }
                
                let _ = try? self.client.conversation.conversations[2].send(data)
                
                expect(self.client.conversation.conversations[0].uuid).toEventually(equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
                expect(self.client.conversation.conversations[2].uuid).toEventuallyNot(equal(TestConstants.Conversation.uuid), timeout: 5, pollInterval: 1)
            }
        }
        
        context("receive image") {
            it("should pass") {
                guard let token = ["template": "default,image",
                                   "from": TestConstants.PeerMember.uuid,
                                   "image_event_id": 5,
                                   "wait": "3"].JSONString else {
                                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                var responseImage: EventBase?
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                conversation.newEventReceived.addHandler { event in
                    responseImage = event
                }
                
                // TODO: test case fails due to there not been sent a conversation
                expect(responseImage).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(responseImage?.fromMember.uuid).toEventually(equal(TestConstants.PeerMember.uuid), timeout: 5, pollInterval: 1)
                expect(responseImage?.from.uuid).toEventually(equal(TestConstants.PeerUser.uuid), timeout: 5, pollInterval: 1)
            }
            
            it("receipt should be created") {
                guard let token = ["template": "default,image",
                                   "from": TestConstants.PeerMember.uuid,
                                   "image_event_id": 5,
                                   "wait": "3"].JSONString else {
                                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                var responseImage: EventBase?
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                conversation.newEventReceived.addHandler { event in
                    responseImage = event
                }
                
                // TODO: test case fails due to there not been sent a conversation
                expect(responseImage).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect((responseImage as? ImageEvent)?.allReceipts.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
            }
            
            it("should change conversations order for multiple conversations") {
                guard let token = ["template": ["session:success": "default,image",
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
