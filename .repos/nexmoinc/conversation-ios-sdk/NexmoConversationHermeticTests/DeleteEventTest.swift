//
//  DeleteEventTest.swift
//  NexmoConversation
//
//  Created by Ivan on 17/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import XCTest
import Quick
import Nimble
import NexmoConversation

class DeleteEventTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    let client = ConversationClient.instance
    
    override func spec() {
        
        beforeEach {

        }
        
        afterEach {
            BasicOperations.logout(client: self.client)
        }
        
        context("send delete event") {
            it("should pass for text") {
                guard let token = ["text_id": 4,
                                   "event_id": 4].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                var returnedEvent: TextEvent?
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                guard let _ = try? conversation.send(TestConstants.Text.text) else { return fail() }
                
                expect(conversation.allEvents.count).toEventually(equal(5), timeout: 5, pollInterval: 1)
                expect(conversation.allEvents.last?.description).toEventually(equal("(TextEvent)(conversation=CON-sdk-test, eventId=4)"), timeout: 5, pollInterval: 1)
                
                returnedEvent = conversation.allEvents.last as? TextEvent
                
                expect(returnedEvent?.text).toEventually(equal(TestConstants.Text.text), timeout: 5, pollInterval: 1)
                
                let success = returnedEvent?.delete()
                
                expect(success).toEventually(beTrue(), timeout: 5, pollInterval: 1)
                
                expect((conversation.allEvents.last as? TextEvent)?.text).toEventually(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("should pass for image") {
                guard let token = ["image_id": 4,
                                   "event_id": 4].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                var returnedEvent: ImageEvent?
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                guard let image = UIImage(named: AssetsTest.nexmo.path, in: Bundle(for: type(of: self)), compatibleWith: nil) else { return fail() }
                guard let data = UIImageJPEGRepresentation(image, 0.75) else { return fail() }
                
                guard let _ = try? conversation.send(data) else { return fail() }
                
                expect(conversation.allEvents.count).toEventually(equal(5), timeout: 5, pollInterval: 1)
                expect(conversation.allEvents.last?.description).toEventually(equal("(ImageEvent)(conversation=CON-sdk-test, eventId=4)"), timeout: 5, pollInterval: 1)
                
                returnedEvent = conversation.allEvents.last as? ImageEvent
                
                expect(returnedEvent?.image).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                
                let success = returnedEvent?.delete()
                
                expect(success).toEventually(beTrue(), timeout: 5, pollInterval: 1)
                
                expect((conversation.allEvents.last as? ImageEvent)?.image).toEventually(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("should pass for text retrieved on sync") {
                BasicOperations.login(with: self.client)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                expect(conversation.allEvents.count).toEventually(equal(4), timeout: 5, pollInterval: 1)
                
                guard let myText = conversation.allEvents[2] as? TextEvent else { return fail() }
                
                let success = conversation.delete(myText)
                
                expect(success).toEventually(beTrue(), timeout: 5, pollInterval: 1)
                
                expect((conversation.allEvents[2] as? TextEvent)?.text).toEventually(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("should pass for image retrieved on sync") {
                guard let token = ["template": "event-list-image"].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                expect(conversation.allEvents.count).toEventually(equal(4), timeout: 5, pollInterval: 1)
                
                guard let myImage = conversation.allEvents[2] as? ImageEvent else { return fail() }
                
                let success = conversation.delete(myImage)
                
                expect(success).toEventually(beTrue(), timeout: 5, pollInterval: 1)
                
                expect((conversation.allEvents[2] as? ImageEvent)?.image).toEventually(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("should fail if it is not my text retrieved on sync") {
                guard let token = ["event_id": 3].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                expect(conversation.allEvents.count).toEventually(equal(4), timeout: 5, pollInterval: 1)
                
                guard let myText = conversation.allEvents.last as? TextEvent else { return fail() }
                
                let success = conversation.delete(myText)
                
                expect(success).toEventually(beFalse(), timeout: 5, pollInterval: 1)
                
                expect((conversation.allEvents.last as? TextEvent)?.text).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("should fail if it is not my image retrieved on sync") {
                guard let token = ["template": "event-list-image", "event_id": 3].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                expect(conversation.allEvents.count).toEventually(equal(4), timeout: 5, pollInterval: 1)
                
                guard let myImage = conversation.allEvents.last as? ImageEvent else { return fail() }
                
                let success = conversation.delete(myImage)
                
                expect(success).toEventually(beFalse(), timeout: 5, pollInterval: 1)
                
                expect((conversation.allEvents.last as? ImageEvent)?.image).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("should fail when malformed JSON is returned by server") {
                let token = TokenBuilder(response: .setStatusGetDeleteEvent).delete.build
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                expect(conversation.allEvents.count).toEventually(equal(4), timeout: 5, pollInterval: 1)
                
                guard let myText = conversation.allEvents[2] as? TextEvent else { return fail() }
                
                let success = conversation.delete(myText)
                
                expect(success).toEventually(beFalse(), timeout: 5, pollInterval: 1)
                
                expect((conversation.allEvents[2] as? TextEvent)?.text).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
            }
        }
        
        context("receive delete event") {
            it("should pass for own retrieved text") {
                guard let token = ["template": "default,event_deleted",
                                   "deleted_event_id": 2,
                                   "from_delete": TestConstants.Member.uuid,
                                   "wait": "5"].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                expect(conversation.allEvents.count).toEventually(equal(4), timeout: 5, pollInterval: 1)
                
                expect((conversation.allEvents[2] as? TextEvent)?.text).toNot(beNil())
                
                expect((conversation.allEvents[2] as? TextEvent)?.text).toEventually(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("should pass for own retrieved image") {
                guard let token = ["template": "default,event_deleted,event-list-image",
                                   "deleted_event_id": 2,
                                   "from_delete": TestConstants.Member.uuid,
                                   "wait": "5"].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                expect(conversation.allEvents.count).toEventually(equal(4), timeout: 5, pollInterval: 1)
                
                expect((conversation.allEvents[2] as? ImageEvent)?.image).toNot(beNil())
                
                expect((conversation.allEvents[2] as? ImageEvent)?.image).toEventually(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("should pass for another member retrieved text") {
                guard let token = ["template": "default,event_deleted",
                                   "deleted_event_id": 3,
                                   "from_delete": TestConstants.PeerMember.uuid,
                                   "wait": "5"].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                expect(conversation.allEvents.count).toEventually(equal(4), timeout: 5, pollInterval: 1)
                
                expect((conversation.allEvents.last as? TextEvent)?.text).toNot(beNil())
                
                expect((conversation.allEvents.last as? TextEvent)?.text).toEventually(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("should pass for another member retrieved image") {
                guard let token = ["template": "default,event_deleted,event-list-image",
                                   "deleted_event_id": 3,
                                   "from_delete": TestConstants.PeerMember.uuid,
                                   "wait": "5"].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                expect(conversation.allEvents.count).toEventually(equal(4), timeout: 5, pollInterval: 1)
                
                expect((conversation.allEvents.last as? ImageEvent)?.image).toNot(beNil())
                
                expect((conversation.allEvents.last as? ImageEvent)?.image).toEventually(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("should pass for sent text") {
                guard let token = ["template": "default,event_deleted",
                                   "text_id": 4,
                                   "deleted_event_id": 4,
                                   "from_delete": TestConstants.Member.uuid,
                                   "wait": "5"].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                var returnedEvent: TextEvent?
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                guard let _ = try? conversation.send(TestConstants.Text.text) else { return fail() }
                
                expect(conversation.allEvents.count).toEventually(equal(5), timeout: 5, pollInterval: 1)
                expect(conversation.allEvents.last?.description).toEventually(equal("(TextEvent)(conversation=CON-sdk-test, eventId=4)"), timeout: 5, pollInterval: 1)
                
                returnedEvent = conversation.allEvents.last as? TextEvent
                
                expect(returnedEvent?.text).toEventually(equal(TestConstants.Text.text), timeout: 5, pollInterval: 1)
                
                expect((conversation.allEvents.last as? TextEvent)?.text).toEventually(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("should pass for sent image") {
                guard let token = ["template": "default,event_deleted",
                                   "image_id": 4,
                                   "deleted_event_id": 4,
                                   "from_delete": TestConstants.Member.uuid,
                                   "wait": "5"].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                var returnedEvent: ImageEvent?
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                guard let image = UIImage(named: AssetsTest.nexmo.path, in: Bundle(for: type(of: self)), compatibleWith: nil) else { return fail() }
                guard let data = UIImageJPEGRepresentation(image, 0.75) else { return fail() }
                
                guard let _ = try? conversation.send(data) else { return fail() }
                
                expect(conversation.allEvents.count).toEventually(equal(5), timeout: 5, pollInterval: 1)
                expect(conversation.allEvents.last?.description).toEventually(equal("(ImageEvent)(conversation=CON-sdk-test, eventId=4)"), timeout: 5, pollInterval: 1)
                
                returnedEvent = conversation.allEvents.last as? ImageEvent
                
                expect(returnedEvent?.image).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                
                expect((conversation.allEvents.last as? ImageEvent)?.image).toEventually(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("should pass for own received text") {
                guard let token = ["template": "default,text,event_deleted",
                                   "text_event_id": 4,
                                   "deleted_event_id": 4,
                                   "from": TestConstants.Member.uuid,
                                   "from_delete": TestConstants.Member.uuid,
                                   "wait": "3"].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                expect(conversation.allEvents.count).toEventually(equal(5), timeout: 5, pollInterval: 1)
                
                expect((conversation.allEvents.last as? TextEvent)?.text).toEventually(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("should pass for own received image") {
                guard let token = ["template": "default,image,event_deleted",
                                   "image_event_id": 4,
                                   "deleted_event_id": 4,
                                   "from": TestConstants.Member.uuid,
                                   "from_delete": TestConstants.Member.uuid,
                                   "wait": "3"].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                expect(conversation.allEvents.count).toEventually(equal(5), timeout: 5, pollInterval: 1)
                
                expect((conversation.allEvents.last as? ImageEvent)?.image).toEventually(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("should pass for received text from another member") {
                guard let token = ["template": "default,text,event_deleted",
                                   "text_event_id": 4,
                                   "deleted_event_id": 4,
                                   "from": TestConstants.PeerMember.uuid,
                                   "from_delete": TestConstants.PeerMember.uuid,
                                   "wait": "3"].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                expect(conversation.allEvents.count).toEventually(equal(5), timeout: 5, pollInterval: 1)
                expect((conversation.allEvents.last as? TextEvent)?.allReceipts.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                
                expect((conversation.allEvents.last as? TextEvent)?.text).toEventually(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("should pass for received image from another member") {
                guard let token = ["template": "default,image,event_deleted",
                                   "image_event_id": 4,
                                   "deleted_event_id": 4,
                                   "from": TestConstants.PeerMember.uuid,
                                   "from_delete": TestConstants.PeerMember.uuid,
                                   "wait": "3"].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                expect(conversation.allEvents.count).toEventually(equal(5), timeout: 5, pollInterval: 1)
                expect((conversation.allEvents.last as? ImageEvent)?.allReceipts.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                
                expect((conversation.allEvents.last as? ImageEvent)?.image).toEventually(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("should fail in case of unknown event") {
                guard let token = ["template": "default,event_deleted",
                                   "deleted_event_id": 10,
                                   "from_delete": TestConstants.Member.uuid,
                                   "wait": "5"].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                expect(conversation.allEvents.count).toEventually(equal(4), timeout: 5, pollInterval: 1)
                
                expect((conversation.allEvents[2] as? TextEvent)?.text).toNot(beNil())
                
                expect((conversation.allEvents[2] as? TextEvent)?.text).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
            }
        }
    }
}
