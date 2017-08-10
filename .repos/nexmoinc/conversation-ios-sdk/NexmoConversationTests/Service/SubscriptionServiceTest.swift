//
//  SubscriptionServiceTest.swift
//  NexmoConversation
//
//  Created by shams ahmed on 22/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import UIKit
import Quick
import Nimble
import Mockingjay
import RxSwift
import RxTest
import RxBlocking
@testable import NexmoConversation

internal class SubscriptionServiceTest: QuickSpec {
    
    let webSocketManager = WebSocketManager(queue: DispatchQueue.parsering)
    lazy var service: SubscriptionService = { return SubscriptionService(webSocketManager: self.webSocketManager) }()
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        // DISABLED
        it("validates member listeners") {
            var event: NexmoConversation.Event?
            
            _ = self.service.events.asObservable()
                .filterNil()
                .subscribe(onNext: { newEvent in
                event = newEvent
            })
            
            self.webSocketManager.testListener(Event.EventType.memberInvited.rawValue, with: [])
            self.webSocketManager.testListener(Event.EventType.memberJoined.rawValue, with: [])
            self.webSocketManager.testListener(Event.EventType.memberLeft.rawValue, with: [])
            
            // TODO: implement test cases
            expect(event?.type).toEventually(equal(Event.EventType.memberInvited))
            expect(event?.type).toEventually(equal(Event.EventType.memberJoined))
            expect(event?.type).toEventually(equal(Event.EventType.memberLeft))
        }

        // DISABLED
        it("validates text listeners") {
            var event: NexmoConversation.Event?
            
            _ = self.service.events.asObservable()
                .filterNil()
                .subscribe(onNext: { newEvent in
                event = newEvent
            })
            
            // TODO: implement test cases
            expect(event?.type).toEventually(equal(Event.EventType.textTypingOn))
            expect(event?.type).toEventually(equal(Event.EventType.textTypingOff))
            expect(event?.type).toEventually(equal(Event.EventType.textSeen))
            expect(event?.type).toEventually(equal(Event.EventType.textDelivered))
            expect(event?.type).toEventually(equal(Event.EventType.text))
            
            self.webSocketManager.testListener(Event.EventType.textTypingOn.rawValue, with: [])
            self.webSocketManager.testListener(Event.EventType.textTypingOff.rawValue, with: [])
            self.webSocketManager.testListener(Event.EventType.textSeen.rawValue, with: [])
            self.webSocketManager.testListener(Event.EventType.textDelivered.rawValue, with: [])
            self.webSocketManager.testListener(Event.EventType.text.rawValue, with: [])
        }

        // DISABLED
        it("validates event listeners") {
            var event: NexmoConversation.Event?
            
            _ = self.service.events.asObservable()
                .filterNil()
                .subscribe(onNext: { newEvent in
                event = newEvent
            })
            
            // TODO: implement test cases
            expect(event?.type).toEventually(equal(Event.EventType.eventDelete))
            expect(event?.type).toEventually(equal(Event.EventType.image))
            expect(event?.type).toEventually(equal(Event.EventType.imageDelivered))
            
            self.webSocketManager.testListener(Event.EventType.eventDelete.rawValue, with: [])
            self.webSocketManager.testListener(Event.EventType.image.rawValue, with: [])
            self.webSocketManager.testListener(Event.EventType.imageDelivered.rawValue, with: [])
        }
    }
}
