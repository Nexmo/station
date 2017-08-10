//
//  EventTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 09/12/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class EventTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("create a full member joined event model with json") {
            let json = self.json(path: .memberJoinedEvent)
            let event = Event(json: json)
            
            expect(event).toNot(beNil())
        }
        
        it("fail to create a full member joined event model with json") {
            let event = Event(json: [
                "from": "from",
                "to": "to"
                ]
            )
            
            expect(event).to(beNil())
        }
        
        it("fail to create a full member joined event model with bad json") {
            let event = Event(json: [
                "from": "from",
                "to": "to",
                "cid": ""
                ]
            )
            
            expect(event).to(beNil())
        }
        
        it("fail to create a full member joined event model with bad timestamp json") {
            let event = Event(json: [
                "from": "from",
                "to": "to",
                "cid": "",
                "body": [:],
                "timestamp": "some time"
                ]
            )
            
            expect(event).to(beNil())
        }
        
        it("create a member joined event model with json") {
            let json = self.json(path: .memberJoinedEvent)
            let event = Event(conversationUuid: "1", json: json)
            
            expect(event).toNot(beNil())
        }
        
        it("create a text event model with json") {
            let json = self.json(path: .textEvent)
            let event = Event(conversationUuid: "1", json: json)
            
            expect(event).toNot(beNil())
        }
        
        it("fail to create a text event model with no body ") {
            let event = Event(
                conversationUuid: "1",
                json: [
                    "from": "from",
                    "to": "to"
                ]
            )
            
            expect(event).to(beNil())
        }
        
        it("fail to create a text event model with bad timestamp ") {
            let event = Event(
                conversationUuid: "1",
                json: [
                    "from": "from",
                    "to": "to",
                    "body": [:]
                ]
            )
            
            expect(event).to(beNil())
        }
        
        it("manual create a member joined event model with date") {
            let event = Event(cid: "cid", id: 1, from: "from", to: "to", timestamp: Date(), type: .text)
            
            expect(event).toNot(beNil())
        }
        
        it("manual create a text event event model with json") {
            let event = Event(cid: "cid", type: .image, memberId: "")
            
            expect(event).toNot(beNil())
        }
        
        it("create a event state model") {
            // TODO: add real mock values
            let state = EventState(json: [:])
            
            expect(state).toNot(beNil())
        }
        
        it("fails to find error message") {
            expect(Event.Errors.build(nil)) == Event.Errors.unknown
        }
        
        it("create a event state for not found") {
            let rawData = "{\"code\": \"event:error:not-found\",\"description\": \"testing...\"}".data(using: .utf8)
            
            expect(Event.Errors.build(rawData)) == Event.Errors.eventNotFound
        }
        
        it("compares error states") {
            expect(Event.Errors.unknown) == Event.Errors.unknown
            expect(Event.Errors.eventNotFound) == Event.Errors.eventNotFound
            expect(Event.Errors.eventNotFound) != Event.Errors.unknown
        }

        it("fails to match a event type") {
            expect(Event.EventType.image) != Event.EventType.text
        }

        it("fail to create a event state model") {
            // TODO: add real mock values
        }
    }
}
