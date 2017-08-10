//
//  SeenTest.swift
//  NexmoConversation
//
//  Created by Ivan on 17/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import XCTest
import Quick
import Nimble
import NexmoConversation

class SeenTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    let client = ConversationClient.instance
    
    override func spec() {
        
        beforeEach {

        }
        
        afterEach {
            BasicOperations.logout(client: self.client)
        }
        
        context("mark as seen") {
            it("should pass for text from event history") {
                guard let token = ["event_id": 3].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                expect(conversation.allEvents.count).toEventually(equal(4), timeout: 5, pollInterval: 1)
                
                let text = conversation.allEvents.last as? TextEvent
                
                var receiptEvent: TextEvent?
                var receiptRecord: ReceiptRecord?
                
                text?.receiptRecordChanged.addHandler { event, receipt in
                    receiptEvent = event
                    receiptRecord = receipt
                }

                let seen = text?.markAsSeen()

                expect(receiptEvent).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptRecord).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.uuid).toEventually(equal(TestConstants.Conversation.uuid + ":3"), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.text).toEventually(equal(TestConstants.Text.text), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.fromMember.uuid).toEventually(equal(TestConstants.PeerMember.uuid), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.fromMember.user.uuid).toEventually(equal(String(TestConstants.PeerUser.uuid)), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.fromMember.user.name).toEventually(equal(TestConstants.PeerUser.name), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.from.uuid).toEventually(equal(TestConstants.PeerUser.uuid), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.from.name).toEventually(equal(TestConstants.PeerUser.name), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.date).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.state).toEventually(equal(.seen), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.event.uuid).toEventually(equal(receiptEvent?.uuid), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.member.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)

                expect(seen).toEventually(beTrue(), timeout: 5, pollInterval: 1)
                expect(text?.uuid).toEventually(equal(TestConstants.Conversation.uuid + ":3"), timeout: 5, pollInterval: 1)
                expect(text?.allReceipts.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                expect(text?.fromMember.uuid).toEventually(equal(TestConstants.PeerMember.uuid), timeout: 5, pollInterval: 1)
                expect(text?.allReceipts.first?.state).toEventually(equal(.seen), timeout: 5, pollInterval: 1)
                expect(text?.allReceipts.first?.date).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(text?.allReceipts.first?.event.uuid).toEventually(equal(text?.uuid), timeout: 5, pollInterval: 1)
                expect(text?.allReceipts.first?.event.fromMember.uuid).toEventually(equal(TestConstants.PeerMember.uuid), timeout: 5, pollInterval: 1)
                expect(text?.allReceipts.first?.member.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                expect(text?.allReceipts.first?.member.state).toEventually(equal(.joined), timeout: 5, pollInterval: 1)
                expect(text?.allReceipts.first?.member.user.uuid).toEventually(equal(TestConstants.User.uuid), timeout: 5, pollInterval: 1)
                expect(text?.allReceipts.first?.member.user.name).toEventually(equal(TestConstants.User.name), timeout: 5, pollInterval: 1)
            }
            
            it("should pass for image from event history") {
                guard let token = ["template": "event-list-image", "event_id": 3].JSONString else { return fail() }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                expect(conversation.allEvents.count).toEventually(equal(4), timeout: 5, pollInterval: 1)
                
                let image = conversation.allEvents.last as? ImageEvent
                
                var receiptEvent: ImageEvent?
                var receiptRecord: ReceiptRecord?
                
                image?.receiptRecordChanged.addHandler{ event, receipt in
                    receiptEvent = event as? ImageEvent
                    receiptRecord = receipt
                }
                
                let seen = image?.markAsSeen()
                
                expect(receiptEvent).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptRecord).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.uuid).toEventually(equal(TestConstants.Conversation.uuid + ":3"), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.fromMember.uuid).toEventually(equal(TestConstants.PeerMember.uuid), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.fromMember.user.uuid).toEventually(equal(String(TestConstants.PeerUser.uuid)), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.fromMember.user.name).toEventually(equal(TestConstants.PeerUser.name), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.from.uuid).toEventually(equal(TestConstants.PeerUser.uuid), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.from.name).toEventually(equal(TestConstants.PeerUser.name), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.date).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.state).toEventually(equal(.seen), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.event.uuid).toEventually(equal(receiptEvent?.uuid), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.member.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                
                expect(seen).toEventually(beTrue(), timeout: 5, pollInterval: 1)
                expect(image?.uuid).toEventually(equal(TestConstants.Conversation.uuid + ":3"), timeout: 5, pollInterval: 1)
                expect(image?.allReceipts.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                expect(image?.fromMember.uuid).toEventually(equal(TestConstants.PeerMember.uuid), timeout: 5, pollInterval: 1)
                expect(image?.allReceipts.first?.state).toEventually(equal(.seen), timeout: 5, pollInterval: 1)
                expect(image?.allReceipts.first?.date).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(image?.allReceipts.first?.event.uuid).toEventually(equal(image?.uuid), timeout: 5, pollInterval: 1)
                expect(image?.allReceipts.first?.event.fromMember.uuid).toEventually(equal(TestConstants.PeerMember.uuid), timeout: 5, pollInterval: 1)
                expect(image?.allReceipts.first?.member.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                expect(image?.allReceipts.first?.member.state).toEventually(equal(.joined), timeout: 5, pollInterval: 1)
                expect(image?.allReceipts.first?.member.user.uuid).toEventually(equal(TestConstants.User.uuid), timeout: 5, pollInterval: 1)
                expect(image?.allReceipts.first?.member.user.name).toEventually(equal(TestConstants.User.name), timeout: 5, pollInterval: 1)
            }
            
            it("should pass for received text") {
                guard let token = ["template": "default,text",
                                   "from": TestConstants.PeerMember.uuid,
                                   "text_event_id": TestConstants.Text.uuid,
                                   "event_id": TestConstants.Text.uuid,
                                   "wait": 3].JSONString else {
                                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                expect(conversation.allEvents.count).toEventually(equal(5), timeout: 5, pollInterval: 1)
                
                let text = conversation.allEvents.last as? TextEvent
                
                var receiptEvent: TextEvent?
                var receiptRecord: ReceiptRecord?
                
                text?.receiptRecordChanged.addHandler { event, receipt in
                    receiptEvent = event
                    receiptRecord = receipt
                }
                
                let seen = text?.markAsSeen()
                
                expect(receiptEvent).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptRecord).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.uuid).toEventually(equal(TestConstants.Conversation.uuid + ":" + String(TestConstants.Text.uuid)), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.fromMember.uuid).toEventually(equal(TestConstants.PeerMember.uuid), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.fromMember.user.uuid).toEventually(equal(String(TestConstants.PeerUser.uuid)), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.fromMember.user.name).toEventually(equal(TestConstants.PeerUser.name), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.from.uuid).toEventually(equal(TestConstants.PeerUser.uuid), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.from.name).toEventually(equal(TestConstants.PeerUser.name), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.date).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.state).toEventually(equal(.seen), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.event.uuid).toEventually(equal(receiptEvent?.uuid), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.member.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                
                expect(seen).toEventually(beTrue(), timeout: 5, pollInterval: 1)
                expect(text?.allReceipts.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                expect(text?.fromMember.uuid).toEventually(equal(TestConstants.PeerMember.uuid), timeout: 5, pollInterval: 1)
                expect(text?.allReceipts.first?.state).toEventually(equal(.seen), timeout: 5, pollInterval: 1)
                expect(text?.allReceipts.first?.date).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(text?.allReceipts.first?.event.uuid).toEventually(equal(text?.uuid), timeout: 5, pollInterval: 1)
                expect(text?.allReceipts.first?.event.fromMember.uuid).toEventually(equal(TestConstants.PeerMember.uuid), timeout: 5, pollInterval: 1)
                expect(text?.allReceipts.first?.member.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                expect(text?.allReceipts.first?.member.state).toEventually(equal(.joined), timeout: 5, pollInterval: 1)
                expect(text?.allReceipts.first?.member.user.uuid).toEventually(equal(TestConstants.User.uuid), timeout: 5, pollInterval: 1)
                expect(text?.allReceipts.first?.member.user.name).toEventually(equal(TestConstants.User.name), timeout: 5, pollInterval: 1)
            }
            
            it("should pass for received image") {
                guard let token = ["template": "default,image",
                                   "from": TestConstants.PeerMember.uuid,
                                   "image_event_id": TestConstants.Image.uuid,
                                   "event_id": TestConstants.Image.uuid,
                                   "wait": 3].JSONString else {
                                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                expect(conversation.allEvents.count).toEventually(equal(5), timeout: 5, pollInterval: 1)
                
                let image = conversation.allEvents.last as? ImageEvent
                
                var receiptEvent: ImageEvent?
                var receiptRecord: ReceiptRecord?
                
                image?.receiptRecordChanged.addHandler{ event, receipt in
                    receiptEvent = event as? ImageEvent
                    receiptRecord = receipt
                }
                
                let seen = image?.markAsSeen()
                
                expect(receiptEvent).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptRecord).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.uuid).toEventually(equal(TestConstants.Conversation.uuid + ":" + String(TestConstants.Image.uuid)), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.fromMember.uuid).toEventually(equal(TestConstants.PeerMember.uuid), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.fromMember.user.uuid).toEventually(equal(String(TestConstants.PeerUser.uuid)), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.fromMember.user.name).toEventually(equal(TestConstants.PeerUser.name), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.from.uuid).toEventually(equal(TestConstants.PeerUser.uuid), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.from.name).toEventually(equal(TestConstants.PeerUser.name), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.date).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.state).toEventually(equal(.seen), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.event.uuid).toEventually(equal(receiptEvent?.uuid), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.member.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                
                expect(seen).toEventually(beTrue(), timeout: 5, pollInterval: 1)
                expect(image?.allReceipts.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                expect(image?.fromMember.uuid).toEventually(equal(TestConstants.PeerMember.uuid), timeout: 5, pollInterval: 1)
                expect(image?.allReceipts.first?.state).toEventually(equal(.seen), timeout: 5, pollInterval: 1)
                expect(image?.allReceipts.first?.date).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(image?.allReceipts.first?.event.uuid).toEventually(equal(image?.uuid), timeout: 5, pollInterval: 1)
                expect(image?.allReceipts.first?.event.fromMember.uuid).toEventually(equal(TestConstants.PeerMember.uuid), timeout: 5, pollInterval: 1)
                expect(image?.allReceipts.first?.member.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                expect(image?.allReceipts.first?.member.state).toEventually(equal(.joined), timeout: 5, pollInterval: 1)
                expect(image?.allReceipts.first?.member.user.uuid).toEventually(equal(TestConstants.User.uuid), timeout: 5, pollInterval: 1)
                expect(image?.allReceipts.first?.member.user.name).toEventually(equal(TestConstants.User.name), timeout: 5, pollInterval: 1)
            }
            
            it("user should not be able to mark as seen own text") {
                BasicOperations.login(with: self.client)
                
                var seenResponse = false

                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                guard let textEvent = conversation.allEvents.last as? TextEvent else { return fail() }
                
                textEvent.markAsSeen()

                conversation.events.addHandler { _ in
                    seenResponse = true
                }

                expect(seenResponse).toEventually(beFalse(), timeout: 5, pollInterval: 1)
            }
            
            it("user should not be able to mark as seen same text twice") {
                BasicOperations.login(with: self.client)
                
                guard let textEvent = self.client.conversation.conversations.first?.allEvents.last as? TextEvent else { return fail() }
                
                let seen1 = textEvent.markAsSeen()
                let seen2 = textEvent.markAsSeen()
                
                expect(textEvent).toEventuallyNot(beNil())
                expect(seen1).toEventually(beTrue(), timeout: 5, pollInterval: 1)
                expect(seen2).toEventually(beFalse(), timeout: 5, pollInterval: 1)
            }
        }
        
        context("receive a seen event") {
            it("should pass in case of sent text") {
                var responseText: TextEvent?
                var receiptEvent: TextEvent?
                var receiptRecord: ReceiptRecord?
                
                guard let token = ["template": "default,text_seen",
                                   "text_id": TestConstants.Text.uuid,
                                   "event_id": TestConstants.Text.uuid,
                                   "seen_from": TestConstants.PeerMember.uuid,
                                   "seen_cid": TestConstants.Conversation.uuid,
                                   "seen_event_id": TestConstants.Text.uuid,
                                   "wait": 5].JSONString else {
                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                let conversation = self.client.conversation.conversations.first
                conversation?.newEventReceived.addHandler { responseText = $0 as? TextEvent }
                
                guard let _ = try? conversation?.send(TestConstants.Text.text) == nil else { return fail() }
                
                expect(responseText).toEventuallyNot(beNil(), timeout: 10, pollInterval: 1)
                expect(responseText?.fromMember.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                expect(responseText?.from.uuid).toEventually(equal(TestConstants.User.uuid), timeout: 5, pollInterval: 1)
                
                responseText?.newReceiptRecord.addHandler { event, receipt in
                    receiptEvent = event
                    receiptRecord = receipt
                }
                
                expect(receiptEvent).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptRecord).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.uuid).toEventually(equal(TestConstants.Conversation.uuid + ":" + String(TestConstants.Text.uuid)), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.text).toEventually(equal(TestConstants.Text.text), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.fromMember.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.fromMember.user.uuid).toEventually(equal(String(TestConstants.User.uuid)), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.fromMember.user.name).toEventually(equal(TestConstants.User.name), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.from.uuid).toEventually(equal(TestConstants.User.uuid), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.from.name).toEventually(equal(TestConstants.User.name), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.date).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.state).toEventually(equal(.seen), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.event.uuid).toEventually(equal(receiptEvent?.uuid), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.member.uuid).toEventually(equal(TestConstants.PeerMember.uuid), timeout: 5, pollInterval: 1)
            }
            
            it("should pass in case of sent image") {
                var responseImage: ImageEvent?
                var receiptEvent: ImageEvent?
                var receiptRecord: ReceiptRecord?
                
                guard let token = ["template": "default,image_seen",
                                   "image_id": TestConstants.Image.uuid,
                                   "event_id": TestConstants.Image.uuid,
                                   "seen_from": TestConstants.PeerMember.uuid,
                                   "seen_cid": TestConstants.Conversation.uuid,
                                   "seen_event_id": TestConstants.Image.uuid,
                                   "wait": 5].JSONString else {
                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                conversation.newEventReceived.addHandler { responseImage = $0 as? ImageEvent }
                
                guard let image = UIImage(named: AssetsTest.nexmo.path, in: Bundle(for: type(of: self)), compatibleWith: nil) else { return fail() }
                guard let data = UIImageJPEGRepresentation(image, 0.75) else { return fail() }
                
                guard let _ = try? conversation.send(data) else { return fail() }
                
                expect(responseImage).toEventuallyNot(beNil(), timeout: 10, pollInterval: 1)
                expect(responseImage?.fromMember.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                expect(responseImage?.from.uuid).toEventually(equal(TestConstants.User.uuid), timeout: 5, pollInterval: 1)
                
                responseImage?.newReceiptRecord.addHandler { event, receipt in
                    receiptEvent = event as? ImageEvent
                    receiptRecord = receipt
                }
                
                expect(receiptEvent).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptRecord).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.uuid).toEventually(equal(TestConstants.Conversation.uuid + ":" + String(TestConstants.Image.uuid)), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.fromMember.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.fromMember.user.uuid).toEventually(equal(String(TestConstants.User.uuid)), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.fromMember.user.name).toEventually(equal(TestConstants.User.name), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.from.uuid).toEventually(equal(TestConstants.User.uuid), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.from.name).toEventually(equal(TestConstants.User.name), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.date).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.state).toEventually(equal(.seen), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.event.uuid).toEventually(equal(receiptEvent?.uuid), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.member.uuid).toEventually(equal(TestConstants.PeerMember.uuid), timeout: 5, pollInterval: 1)
            }
            
            it("should pass in case of text from event history") {
                guard let token = ["template": "default,text_seen",
                                   "seen_from": TestConstants.PeerMember.uuid,
                                   "seen_cid": TestConstants.Conversation.uuid,
                                   "seen_event_id": 2,
                                   "wait": 5].JSONString else {
                                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                expect(conversation.allEvents.count).toEventually(equal(4), timeout: 5, pollInterval: 1)
                
                let text = conversation.allEvents[2] as? TextEvent
                
                var receiptEvent: TextEvent?
                var receiptRecord: ReceiptRecord?
                
                text?.newReceiptRecord.addHandler { event, receipt in
                    receiptEvent = event
                    receiptRecord = receipt
                }
                
                expect(receiptEvent).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptRecord).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.uuid).toEventually(equal(TestConstants.Conversation.uuid + ":2"), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.fromMember.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.fromMember.user.uuid).toEventually(equal(String(TestConstants.User.uuid)), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.fromMember.user.name).toEventually(equal(TestConstants.User.name), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.from.uuid).toEventually(equal(TestConstants.User.uuid), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.from.name).toEventually(equal(TestConstants.User.name), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.date).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.state).toEventually(equal(.seen), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.event.uuid).toEventually(equal(receiptEvent?.uuid), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.member.uuid).toEventually(equal(TestConstants.PeerMember.uuid), timeout: 5, pollInterval: 1)
                
                expect(text?.uuid).toEventually(equal(TestConstants.Conversation.uuid + ":2"), timeout: 5, pollInterval: 1)
                expect(text?.allReceipts.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                expect(text?.fromMember.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                expect(text?.allReceipts.first?.state).toEventually(equal(.seen), timeout: 5, pollInterval: 1)
            }
            
            it("should pass in case of image from event history") {
                guard let token = ["template": "default,image_seen,event-list-image",
                                   "seen_from": TestConstants.PeerMember.uuid,
                                   "seen_cid": TestConstants.Conversation.uuid,
                                   "seen_event_id": 2,
                                   "wait": 5].JSONString else {
                                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                expect(conversation.allEvents.count).toEventually(equal(4), timeout: 5, pollInterval: 1)
                
                let image = conversation.allEvents[2] as? ImageEvent
                
                var receiptEvent: ImageEvent?
                var receiptRecord: ReceiptRecord?
                
                image?.newReceiptRecord.addHandler { event, receipt in
                    receiptEvent = event as? ImageEvent
                    receiptRecord = receipt
                }
                
                expect(receiptEvent).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptRecord).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.uuid).toEventually(equal(TestConstants.Conversation.uuid + ":2"), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.fromMember.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.fromMember.user.uuid).toEventually(equal(String(TestConstants.User.uuid)), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.fromMember.user.name).toEventually(equal(TestConstants.User.name), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.from.uuid).toEventually(equal(TestConstants.User.uuid), timeout: 5, pollInterval: 1)
                expect(receiptEvent?.from.name).toEventually(equal(TestConstants.User.name), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.date).toEventuallyNot(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.state).toEventually(equal(.seen), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.event.uuid).toEventually(equal(receiptEvent?.uuid), timeout: 5, pollInterval: 1)
                expect(receiptRecord?.member.uuid).toEventually(equal(TestConstants.PeerMember.uuid), timeout: 5, pollInterval: 1)
                
                expect(image?.uuid).toEventually(equal(TestConstants.Conversation.uuid + ":2"), timeout: 5, pollInterval: 1)
                expect(image?.allReceipts.count).toEventually(equal(1), timeout: 5, pollInterval: 1)
                expect(image?.fromMember.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                expect(image?.allReceipts.first?.state).toEventually(equal(.seen), timeout: 5, pollInterval: 1)
            }
            
            it("should fail in case of unknown text") {
                guard let token = ["template": "default,text_seen",
                                   "seen_from": TestConstants.PeerMember.uuid,
                                   "seen_cid": TestConstants.Conversation.uuid,
                                   "seen_event_id": 10,
                                   "wait": 5].JSONString else {
                                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                expect(conversation.allEvents.count).toEventually(equal(4), timeout: 5, pollInterval: 1)
                
                let text = conversation.allEvents[2] as? TextEvent
                
                var receiptEvent: TextEvent?
                var receiptRecord: ReceiptRecord?
                
                text?.newReceiptRecord.addHandler { event, receipt in
                    receiptEvent = event
                    receiptRecord = receipt
                }
                
                expect(receiptEvent).toEventually(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptRecord).toEventually(beNil(), timeout: 5, pollInterval: 1)
                
                expect(text?.uuid).toEventually(equal(TestConstants.Conversation.uuid + ":2"), timeout: 5, pollInterval: 1)
                expect(text?.allReceipts.count).toEventually(equal(0), timeout: 5, pollInterval: 1)
                expect(text?.fromMember.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                expect(text?.allReceipts.first?.state).toEventually(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("should fail in case of unknown image") {
                guard let token = ["template": "default,image_seen,event-list-image",
                                   "image_id": TestConstants.Image.uuid,
                                   "event_id": TestConstants.Image.uuid,
                                   "seen_from": TestConstants.PeerMember.uuid,
                                   "seen_cid": TestConstants.Conversation.uuid,
                                   "seen_event_id": 10,
                                   "wait": 5].JSONString else {
                                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                expect(conversation.allEvents.count).toEventually(equal(4), timeout: 5, pollInterval: 1)
                
                let image = conversation.allEvents[2] as? ImageEvent
                
                var receiptEvent: ImageEvent?
                var receiptRecord: ReceiptRecord?
                
                image?.newReceiptRecord.addHandler { event, receipt in
                    receiptEvent = event as? ImageEvent
                    receiptRecord = receipt
                }
                
                expect(receiptEvent).toEventually(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptRecord).toEventually(beNil(), timeout: 5, pollInterval: 1)
                
                expect(image?.uuid).toEventually(equal(TestConstants.Conversation.uuid + ":2"), timeout: 5, pollInterval: 1)
                expect(image?.allReceipts.count).toEventually(equal(0), timeout: 5, pollInterval: 1)
                expect(image?.fromMember.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                expect(image?.allReceipts.first?.state).toEventually(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("should fail in case of unknown member for text") {
                guard let token = ["template": "default,text_seen",
                                   "seen_from": "UNKNOWN-MEM",
                                   "seen_cid": TestConstants.Conversation.uuid,
                                   "seen_event_id": 2,
                                   "wait": 5].JSONString else {
                                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                expect(conversation.allEvents.count).toEventually(equal(4), timeout: 5, pollInterval: 1)
                
                let text = conversation.allEvents[2] as? TextEvent
                
                var receiptEvent: TextEvent?
                var receiptRecord: ReceiptRecord?
                
                text?.newReceiptRecord.addHandler { event, receipt in
                    receiptEvent = event
                    receiptRecord = receipt
                }
                
                expect(receiptEvent).toEventually(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptRecord).toEventually(beNil(), timeout: 5, pollInterval: 1)
                
                expect(text?.uuid).toEventually(equal(TestConstants.Conversation.uuid + ":2"), timeout: 5, pollInterval: 1)
                expect(text?.allReceipts.count).toEventually(equal(0), timeout: 5, pollInterval: 1)
                expect(text?.fromMember.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                expect(text?.allReceipts.first?.state).toEventually(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("should fail in case of unknown member for image") {
                guard let token = ["template": "default,image_seen,event-list-image",
                                   "seen_from": "UNKNOWN-MEM",
                                   "seen_cid": TestConstants.Conversation.uuid,
                                   "seen_event_id": 2,
                                   "wait": 5].JSONString else {
                                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                expect(conversation.allEvents.count).toEventually(equal(4), timeout: 5, pollInterval: 1)
                
                let image = conversation.allEvents[2] as? ImageEvent
                
                var receiptEvent: ImageEvent?
                var receiptRecord: ReceiptRecord?
                
                image?.newReceiptRecord.addHandler { event, receipt in
                    receiptEvent = event as? ImageEvent
                    receiptRecord = receipt
                }
                
                expect(receiptEvent).toEventually(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptRecord).toEventually(beNil(), timeout: 5, pollInterval: 1)
                
                expect(image?.uuid).toEventually(equal(TestConstants.Conversation.uuid + ":2"), timeout: 5, pollInterval: 1)
                expect(image?.allReceipts.count).toEventually(equal(0), timeout: 5, pollInterval: 1)
                expect(image?.fromMember.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                expect(image?.allReceipts.first?.state).toEventually(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("should fail in case of unknown conversation for text") {
                guard let token = ["template": "default,text_seen",
                                   "seen_from": TestConstants.PeerMember.uuid,
                                   "seen_cid": "UNKNOWN-CID",
                                   "seen_event_id": 2,
                                   "wait": 5].JSONString else {
                                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                expect(conversation.allEvents.count).toEventually(equal(4), timeout: 5, pollInterval: 1)
                
                let text = conversation.allEvents[2] as? TextEvent
                
                var receiptEvent: TextEvent?
                var receiptRecord: ReceiptRecord?
                
                text?.newReceiptRecord.addHandler { event, receipt in
                    receiptEvent = event
                    receiptRecord = receipt
                }
                
                expect(receiptEvent).toEventually(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptRecord).toEventually(beNil(), timeout: 5, pollInterval: 1)
                
                expect(text?.uuid).toEventually(equal(TestConstants.Conversation.uuid + ":2"), timeout: 5, pollInterval: 1)
                expect(text?.allReceipts.count).toEventually(equal(0), timeout: 5, pollInterval: 1)
                expect(text?.fromMember.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                expect(text?.allReceipts.first?.state).toEventually(beNil(), timeout: 5, pollInterval: 1)
            }
            
            it("should fail in case of unknown conversation for image") {
                guard let token = ["template": "default,image_seen,event-list-image",
                                   "seen_from": TestConstants.PeerMember.uuid,
                                   "seen_cid": "UNKNOWN-CID",
                                   "seen_event_id": 2,
                                   "wait": 5].JSONString else {
                                    return fail()
                }
                
                BasicOperations.login(with: self.client, using: token)
                
                guard let conversation = self.client.conversation.conversations.first else { return fail() }
                expect(conversation.allEvents.count).toEventually(equal(4), timeout: 5, pollInterval: 1)
                
                let image = conversation.allEvents[2] as? ImageEvent
                
                var receiptEvent: ImageEvent?
                var receiptRecord: ReceiptRecord?
                
                image?.newReceiptRecord.addHandler { event, receipt in
                    receiptEvent = event as? ImageEvent
                    receiptRecord = receipt
                }
                
                expect(receiptEvent).toEventually(beNil(), timeout: 5, pollInterval: 1)
                expect(receiptRecord).toEventually(beNil(), timeout: 5, pollInterval: 1)
                
                expect(image?.uuid).toEventually(equal(TestConstants.Conversation.uuid + ":2"), timeout: 5, pollInterval: 1)
                expect(image?.allReceipts.count).toEventually(equal(0), timeout: 5, pollInterval: 1)
                expect(image?.fromMember.uuid).toEventually(equal(TestConstants.Member.uuid), timeout: 5, pollInterval: 1)
                expect(image?.allReceipts.first?.state).toEventually(beNil(), timeout: 5, pollInterval: 1)
            }
        }
    }
}
