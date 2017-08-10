//
//  EventControllerTest.swift
//  NexmoConversation
//
//  Created by shams ahmed on 29/12/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import UIKit
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class EventControllerTest: QuickSpec {
    
    lazy var eventController: EventController = {
        let network = NetworkController(token: "token")
        
        return EventController(network: network)
    }()
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        
        // MARK:
        // MARK: Test
        
        it("should send a passing text event") {
            // parameter
            let event = SendEvent(
                conversationId: "CON-0673a8d7-721c-4c68-8374-cbb080065b00",
                from: "MEM-f9b7175c-1ac5-422f-b332-d206974626c4",
                text: "hello from: \(Date())")
            
            // stub
            self.stub(file: .sendImageMessage, request: EventRouter.send(event: event).urlRequest)
            
            // request
            let response = try? self.eventController.send(event)
                .toBlocking()
                .first()
            
            // test
            expect(response??.id).toEventually(beGreaterThanOrEqualTo(1))
        }
        
        it("sends a fail sending text event") {
            // parameter
            let event = SendEvent(
                conversationId: "CON-0673a8d7-721c-4c68-8374-cbb080065b00",
                from: "MEM-f9b7175c-1ac5-422f-b332-d206974626c4",
                text: "hello from: \(Date())")
            
            // stub
            self.stubClientError(request: EventRouter.send(event: event).urlRequest)
            
            // request
            let response = try? self.eventController.send(event)
                .toBlocking()
                .first()
            
            // test
            expect(response).toEventually(beNil())
        }
        
        it("should send a passing custom event") {
            // parameter
            let event = SendEvent(conversationId: "con-123", from: "mem-123", type: .imageDelivered, body: [:])
            
            // stub
            self.stub(file: .sendImageMessage, request: EventRouter.send(event: event).urlRequest)
            
            // request
            let response = try? self.eventController.send(event)
                .toBlocking()
                .first()
            
            // test
            expect(response??.id).toEventually(beGreaterThanOrEqualTo(1))
        }
        
        it("sends a passing image event") {
            // parameter
            guard let body = UploadedImage(json: self.json(path: JSONTest.uploadedImage))?.toJSON() else { return fail() }
            guard let image = UIImage(named: AssetsTest.nexmo.path, in: Bundle(for: type(of: self)), compatibleWith: nil) else { return fail() }
            guard let data = UIImageJPEGRepresentation(image, 0.75) else { return fail() }
            
            let event = SendEvent(
                conversationId: "CON-0673a8d7-721c-4c68-8374-cbb080065b00",
                from: "MEM-f9b7175c-1ac5-422f-b332-d206974626c4",
                representations: body
            )
            
            let imageParameter: IPSService.UploadImageParameter = (
                image: data,
                size: (originalRatio: nil, mediumRatio: nil, thumbnailRatio: nil)
            )
            
            // stub
            self.stub(file: .uploadedImage, request: IPSRouter.upload().urlRequest)
            self.stub(file: .sendImageMessage, request: EventRouter.send(event: event).urlRequest)
            
            // request
            let response = try? self.eventController.send(imageParameter, conversationId: event.conversationId, fromId: event.from)
                .toBlocking()
                .first()
            
            // test
            expect(response??.id).toEventually(beGreaterThanOrEqualTo(1))
        }
        
        it("sends a bad image event") {
            // parameter
            guard let body = UploadedImage(json: self.json(path: JSONTest.uploadedImage))?.toJSON() else { return fail() }
            guard let image = UIImage(named: AssetsTest.nexmo.path, in: Bundle(for: type(of: self)), compatibleWith: nil) else { return fail() }
            guard let data = UIImageJPEGRepresentation(image, 0.75) else { return fail() }
            
            let event = SendEvent(
                conversationId: "CON-0673a8d7-721c-4c68-8374-cbb080065b00",
                from: "MEM-f9b7175c-1ac5-422f-b332-d206974626c4",
                representations: body
            )
            
            let imageParameter: IPSService.UploadImageParameter = (
                image: data,
                size: (originalRatio: nil, mediumRatio: nil, thumbnailRatio: nil)
            )
            
            // stub
            self.stubClientError(request: EventRouter.send(event: event).urlRequest)
            
            // force fail
            ConversationClient.instance.addAuthorization(with: "Test Mode")
            
            // request
            let response = try? self.eventController.send(imageParameter, conversationId: event.conversationId, fromId: event.from)
                .toBlocking()
                .first()
            
            // remove force fail
            ConversationClient.instance.addAuthorization(with: "auth token...")
            
            // test
            expect(response).toEventually(beNil())
        }
        
        it("sends a event status update") {
            // parameter
            let event = SendEvent(conversationId: "test", from: "test", type: .textDelivered, eventId: 1)
            
            // stub
            self.stub(file: .sendImageMessage, request: EventRouter.send(event: event).urlRequest)
            
            // request
            let response = try? self.eventController.send(event)
                .toBlocking()
                .first()
            
            // test
            expect(response??.id).toEventually(beGreaterThanOrEqualTo(1))
        }
        
        it("fetches all events for a conversation") {
            let conversation = "con-123"
            let range = Range<Int>(uncheckedBounds: (lower: 0, upper: 3))
            
            // stub
            self.stub(file: .events, request: EventRouter.events(conversationUuid: conversation, range: range).urlRequest)
            
            // request
            let events = try? self.eventController.retrieve(for: conversation, with: range)
                .toBlocking()
                .first()
            
            expect(events?.isEmpty()) == false
            expect(events??.first?.cid.isEmpty) == false
        }
        
        it("fetches all events for a conversation with default value") {
            let conversation = "con-123"
            let range = Range<Int>(uncheckedBounds: (lower: 0, upper: 20))
            
            // stub
            self.stub(file: .events, request: EventRouter.events(conversationUuid: conversation, range: range).urlRequest)
            
            // request
            let events = try? self.eventController.retrieve(for: conversation)
                .toBlocking()
                .first()
            
            // test
            expect(events?.isEmpty()) == false
            expect(events??.first?.cid.isEmpty) == false
        }
        
        it("fails to fetch a list of events for a conversation") {
            let conversation = "con-123"
            let range = Range<Int>(uncheckedBounds: (lower: 0, upper: 20))
            
            // stub
            self.stubServerError(request: EventRouter.events(conversationUuid: conversation, range: range).urlRequest)
            
            // request
            let events = try? self.eventController.retrieve(for: conversation)
                .toBlocking()
                .first()
            
            // test
            expect(events).to(beNil())
        }
        
        it("sends a typing event with active") {
            // parameter
            let event = SendEvent(conversationId: "con-123", from: "mem-123", isTyping: true)
            
            // stub
            self.stub(file: .typingOffEvent, request: EventRouter.send(event: event).urlRequest)
            
            // request
            let response = try? self.eventController.send(event)
                .toBlocking()
                .first()
            
            // test
            expect(response??.id).toEventually(beGreaterThanOrEqualTo(1))
        }
        
        it("sends a typing event with not active") {
            // parameter
            let event = SendEvent(conversationId: "con-123", from: "mem-123", isTyping: false)
            
            // stub
            self.stub(file: .typingOffEvent, request: EventRouter.send(event: event).urlRequest)
            
            // request
            let response = try? self.eventController.send(event)
                .toBlocking()
                .first()
            
            // test
            expect(response??.id).toEventually(beGreaterThanOrEqualTo(1))
        }
        
        it("fails to delete a event from a conversation") {
            // stub
            self.stubClientError(request: EventRouter.delete(eventId: 1, conversationUuid: "con-123", memberId: "mem-123").urlRequest)
            
            // request
            let event = try? self.eventController.delete(1, for: "mem-123", in: "con-123")
                .toBlocking()
                .first()
            
            // test
            expect(event).to(beNil())
        }
        
        it("deletes a event from a conversation") {
            // stub
            self.stub(
                file: .deleteEvent,
                request: EventRouter.delete(eventId: 1, conversationUuid: "con-123", memberId: "mem-123").urlRequest
            )
            
            // request
            let event = try? self.eventController.delete(1, for: "mem-123", in: "con-123")
                .toBlocking()
                .first()
            
            // test
            expect(event??.id).toEventually(beGreaterThanOrEqualTo(1))
        }
        
        it("sends bad json for deleting a event") {
            // stub
            self.stub(json: [:], request: EventRouter.delete(eventId: 1, conversationUuid: "con-123", memberId: "mem-123").urlRequest)
            
            // request
            let event = try? self.eventController.delete(1, for: "mem-123", in: "con-123")
                .toBlocking()
                .first()
            
            // test
            expect(event??.id).to(beNil())
        }
    }
}
