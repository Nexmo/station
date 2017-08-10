//
//  DeliveredTest.swift
//  NexmoConversation
//
//  Created by Ivan on 17/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import XCTest
import Quick
import Nimble
import NexmoConversation

class DeliveredTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    let client = ConversationClient.instance
    
    override func spec() {
        
        beforeEach {

        }
        
        afterEach {
            BasicOperations.logout(client: self.client)
        }
        
        context("received message from another member") {
            it("text should be marked as delivered") {
                var responseText: EventBase?
                
                guard let token = ["template": "default,text",
                                   "from": TestConstants.PeerMember.uuid,
                                   "cid": TestConstants.Conversation.uuid,
                                   "wait": "3",
                                   "text_event_id": 5].JSONString else {
                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                let conversation = self.client.conversation.conversations.first
                
                conversation?.newEventReceived.addHandler { event in
                    responseText = event
                }
                
                expect(responseText).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect((responseText as? TextEvent)?.allReceipts.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                
                guard let receiptDelivered = (responseText as? TextEvent)?.allReceipts.first else { return fail() }
                
                expect(receiptDelivered.state.rawValue).toEventually(equal(ReceiptState.delivered.rawValue), timeout: 5, pollInterval: 1)
                expect(receiptDelivered.date).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("image should be marked as delivered") {
                var responseImage: EventBase?
                
                guard let token = ["template": "default,image",
                                   "from": TestConstants.PeerMember.uuid,
                                   "cid": TestConstants.Conversation.uuid,
                                   "wait": "3",
                                   "image_event_id": 5].JSONString else {
                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                let conversation = self.client.conversation.conversations.first
                
                conversation?.newEventReceived.addHandler { event in
                    responseImage = event
                }
                
                expect(responseImage).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect((responseImage as? TextEvent)?.allReceipts.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                
                guard let receiptDelivered = (responseImage as? ImageEvent)?.allReceipts.first else { return fail() }
                
                expect(receiptDelivered.state.rawValue).toEventually(equal(ReceiptState.delivered.rawValue), timeout: 5, pollInterval: 1)
                expect(receiptDelivered.date).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
            }
        }
        
        context("receive a delivered event for own message") {
            it("should pass in case of text") {
                guard let token = ["template": "default,text_delivered",
                                   "from": TestConstants.PeerMember.uuid,
                                   "cid_delivered": TestConstants.Conversation.uuid,
                                   "delivered_event_id": TestConstants.Text.uuid,
                                   "wait": "5"].JSONString else {
                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                var returnedEvent: EventBase?
                var textEvent: TextEvent?
                var receiptRecord: ReceiptRecord?
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                conversation.newEventReceived.addHandler { event in
                    returnedEvent = event
                }
                
                _ = try? conversation.send(TestConstants.Text.text)
                
                expect(conversation.allEvents.count).toEventually(equal(6), timeout: 5, pollInterval: 1)
                expect((returnedEvent as? TextEvent)?.fromMember.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                
                (conversation.allEvents[4] as? TextEvent)?.newReceiptRecord.addHandler { (event: TextEvent, receipt: ReceiptRecord) in
                    textEvent = event
                    receiptRecord = receipt
                }
                
                expect(textEvent?.allReceipts.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.state.rawValue).toEventually(equal(ReceiptState.delivered.rawValue), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.member.uuid).toEventually(equal(TestConstants.PeerMember.uuid), timeout: 5, pollInterval: 1)
            }
            
            it("should pass in case of image") {
                guard let token = ["template": "default,image_delivered",
                                   "from": TestConstants.PeerMember.uuid,
                                   "cid_delivered": TestConstants.Conversation.uuid,
                                   "delivered_event_id": TestConstants.Image.uuid,
                                   "image_id": TestConstants.Image.uuid,
                                   "wait": "5"].JSONString else {
                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                var returnedEvent: EventBase?
                var imageEvent: TextEvent?
                var receiptRecord: ReceiptRecord?
                
                // listen for new events
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                
                conversation.newEventReceived.addHandler { event in
                    returnedEvent = event
                }
                
                // create event with image
                guard let image = UIImage(named: AssetsTest.nexmo.path, in: Bundle(for: type(of: self)), compatibleWith: nil) else { return fail() }
                guard let data = UIImageJPEGRepresentation(image, 0.75) else { return fail() }
                
                // send event
                _ = try? conversation.send(data)
                
                // test
                expect(conversation.allEvents.count).toEventually(equal(6), timeout: 5, pollInterval: 1)
                expect((returnedEvent as? ImageEvent)?.fromMember.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                
                (conversation.allEvents[4] as? TextEvent)?.newReceiptRecord.addHandler { (event: TextEvent, receipt: ReceiptRecord) in
                    imageEvent = event
                    receiptRecord = receipt
                }
                
                expect(imageEvent?.allReceipts.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.state.rawValue).toEventually(equal(ReceiptState.delivered.rawValue), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.member.uuid).toEventually(equal(TestConstants.PeerMember.uuid), timeout: 5, pollInterval: 1)
            }
        }
    }
}
