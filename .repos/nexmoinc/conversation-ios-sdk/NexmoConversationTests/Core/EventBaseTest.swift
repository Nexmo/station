//
//  EventBaseTest.swift
//  NexmoConversation
//
//  Created by shams ahmed on 06/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import UIKit
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class EventBaseTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        
        // MARK:
        // MARK: Test
        
        it("returns the correct raw event int value") {
            let event1: Event.EventType = .memberInvited
            let event2: Event.EventType = .memberJoined
            let event3: Event.EventType = .memberLeft
            let event4: Event.EventType = .textTypingOn
            let event5: Event.EventType = .textTypingOff
            let event6: Event.EventType = .eventDelete
            let event7: Event.EventType = .text
            let event8: Event.EventType = .textDelivered
            let event9: Event.EventType = .textSeen
            let event10: Event.EventType = .image
            let event11: Event.EventType = .imageDelivered
            
            expect(event1.toInt32) == 1
            expect(event2.toInt32) == 2
            expect(event3.toInt32) == 3
            expect(event4.toInt32) == 4
            expect(event5.toInt32) == 5
            expect(event6.toInt32) == 7
            expect(event7.toInt32) == 6
            expect(event8.toInt32) == 8
            expect(event9.toInt32) == 11
            expect(event10.toInt32) == 9
            expect(event11.toInt32) == 10
        }
        
        it("converts int type to raw event") {
            let event1 = Event.EventType.fromInt32(1)
            let event2 = Event.EventType.fromInt32(2)
            let event3 = Event.EventType.fromInt32(3)
            let event4 = Event.EventType.fromInt32(4)
            let event5 = Event.EventType.fromInt32(5)
            let event6 = Event.EventType.fromInt32(6)
            let event7 = Event.EventType.fromInt32(7)
            let event8 = Event.EventType.fromInt32(8)
            let event9 = Event.EventType.fromInt32(9)
            let event10 = Event.EventType.fromInt32(10)
            let event11 = Event.EventType.fromInt32(11)
            
            expect(event1) == Event.EventType.memberInvited
            expect(event2) == Event.EventType.memberJoined
            expect(event3) == Event.EventType.memberLeft
            expect(event4) == Event.EventType.textTypingOn
            expect(event5) == Event.EventType.textTypingOff
            expect(event6) == Event.EventType.text
            expect(event7) == Event.EventType.eventDelete
            expect(event8) == Event.EventType.textDelivered
            expect(event9) == Event.EventType.image
            expect(event10) == Event.EventType.imageDelivered
            expect(event11) == Event.EventType.textSeen
        }
        
        it("returns nil for unknown values") {
            let event12 = Event.EventType.fromInt32(100)
            
            expect(event12).to(beNil())
        }

        it("comapare to events") {
            let event = Event(cid: "con-123", type: .text, memberId: "mem-123")
            
            let event1 = EventBase(conversationUuid: "con-123", event: event, seen: false)
            let event2 = EventBase(conversationUuid: "con-123", event: event, seen: false)
            
            expect(event1 == event2) == true
        }
        
        it("creates a event from db") {
            let event = DBEvent(
                conversationUuid: "con-123",
                event: Event(cid: "con-123", type: .text, memberId: "mem-123"),
                seen: false
            )
            
            let baseEvent = EventBase(data: event)
            
            expect(baseEvent).toNot(beNil())
        }
        
        it("creates event from a member model") {
            let member = Member(
                conversationUuid: "con-123",
                member: MemberModel("mem-123", name: "test 1", state: .joined, userId: "usr-123", invitedBy: "demo1@nexmo.com", timestamp: [MemberModel.State.joined: Date()])
            )
            
            let baseEvent = EventBase(conversationUuid: "con-123", type: .text, member: member, seen: false)
            
            expect(baseEvent).toNot(beNil())
        }
        
        it("create a event with db factory") {
            let text = DBEvent(
                conversationUuid: "con-123",
                event: Event(cid: "con-123", type: .text, memberId: "mem-123"),
                seen: false
            )
            
            let image = DBEvent(
                conversationUuid: "con-123",
                event: Event(cid: "con-123", type: .image, memberId: "mem-123"),
                seen: false
            )
            
            let base = DBEvent(
                conversationUuid: "con-123",
                event: Event(cid: "con-123", type: .textTypingOff, memberId: "mem-123"),
                seen: false
            )
            
            let textEvent = EventBase.factory(data: text)
            let imageEvent = EventBase.factory(data: image)
            let baseEvent = EventBase.factory(data: base)
            
            expect(textEvent).toNot(beNil())
            expect(imageEvent).toNot(beNil())
            expect(baseEvent).toNot(beNil())
        }
        
        it("creates a event with event model") {
            let text = Event(cid: "con-123", type: .text, memberId: "mem-1")
            let image = Event(cid: "con-123", type: .image, memberId: "mem-1")
            let base = Event(cid: "con-123", type: .textTypingOff, memberId: "mem-1")
            
            let textEvent = EventBase.factory(conversationUuid: "con-123", event: text, seen: false)
            let imageEvent = EventBase.factory(conversationUuid: "con-123", event: image, seen: false)
            let baseEvent = EventBase.factory(conversationUuid: "con-123", event: base, seen: false)
            
            expect(textEvent).toNot(beNil())
            expect(imageEvent).toNot(beNil())
            expect(baseEvent).toNot(beNil())
            expect(baseEvent?.id).toNot(beNil())
        }
        
        it("forms a id from conversation id and event") {
            let base = EventBase.conversationEventId(from: "123:456")
            
            expect(base.1) == 456
        }
        
        it("has a created body from a db event") {
            let event = Event(cid: "con-123", id: 1, from: "mem-1", to: nil, timestamp: Date(), type: .text)
            event.body = ["text": "message 1"]
            
            let base = DBEvent(
                conversationUuid: "con-123",
                event: event,
                seen: false
            )
            
            expect(base.body).toNot(beNil())
        }
        
        it("has a created date from a event") {
            let event = Event(cid: "con-123", id: 1, from: "mem-1", to: nil, timestamp: Date(), type: .text)
            event.body = ["text": "message 1"]
            
            let base = DBEvent(
                conversationUuid: "con-123",
                event: event,
                seen: false
            )
            
            let textEvent = EventBase.factory(data: base)
            
            expect(textEvent?.createDate).toNot(beNil())
        }
        
        it("throws when getting body from string") {
            let event = Event(cid: "con-123", id: 1, from: "mem-1", to: nil, timestamp: Date(), type: .text)
            
            let base = DBEvent(
                conversationUuid: "con-123",
                event: event,
                seen: false
            )
            
            expect { () -> Void in _ = base.body }.to(throwAssertion())
        }
        
        it("has has valid members") {
            let mock = SimpleMockDatabase()
            let baseEvent = EventBase.factory(conversationUuid: mock.conversation1.rest.uuid, event: mock.event1, seen: false)
            
            expect(baseEvent?.from).toNot(beNil())
        }
    }
}
