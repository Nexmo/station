//
//  EventResponseTest.swift
//  NexmoConversation
//
//  Created by shams ahmed on 07/12/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import UIKit
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class EventResponseTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        
        // MARK:
        // MARK: Test
        
        it("create event model") {
            let json = self.json(path: .sendImageMessage)
            
            let model = EventResponse(json: json)
            
            expect(model).toNot(beNil())
        }
        
        it("fail creating event model") {
            let model = EventResponse(json: [:])
            
            expect(model).to(beNil())
        }
        
        it("fail creating event model href") {
            let model = EventResponse(json: ["id": 123])
            
            expect(model).to(beNil())
        }
        
        it("fail creating event model href") {
            let model = EventResponse(json: [
                "id": 123,
                "href": "http://example.com"
                ])
            
            expect(model).to(beNil())
        }
        
        it("creating event model date") {
            let model = EventResponse(json: [
                "id": 123,
                "href": "http://example.com",
                "timestamp": "2016-10-03T09:27:14.875Z"
                ])
            
            expect(model).toNot(beNil())
        }
    }
}
