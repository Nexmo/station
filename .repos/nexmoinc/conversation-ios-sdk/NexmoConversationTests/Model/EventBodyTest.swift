//
//  EventBodyTest.swift
//  NexmoConversation
//
//  Created by shams ahmed on 05/07/2017.
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

internal class EventBodyTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        
        // MARK:
        // MARK: Text Test
        
        it("creates a text event model") {
            expect(Event.Body.Text(json: ["text": "test"])).toNot(beNil())
        }
        
        it("fails to create a text model") {
            expect(Event.Body.Text(json: [:])).to(beNil())
        }

        // MARK:
        // MARK: Image Test

        it("creates a image event model") {
            expect(Event.Body.Image(json: ["image": "test"])).to(beNil())
        }
        
        it("fails to create a image model") {
            expect(Event.Body.Image(json: [:])).to(beNil())
        }

        // MARK:
        // MARK: Delete Test
        
        it("creates a delete event model") {
            expect(Event.Body.Delete(json: ["event_id": "event-1"])).toNot(beNil())
        }
        
        it("fails to create a delete model") {
            expect(Event.Body.Delete(json: [:])).to(beNil())
        }

        // MARK:
        // MARK: Member Invite Test

        it("creates a member invite model") {
            guard let body = self.json(path: .memberInvitedViaSocket)["body"] as? [String: Any] else { return fail() }

            expect(Event.Body.MemberInvite(json: body)).toNot(beNil())
        }

        it("fails to creates a member invite model") {
            expect(Event.Body.MemberInvite(json: [:])).to(beNil())
            expect(Event.Body.MemberInvite(json: ["cname": "", "invited_by": "", "user": ["member_id": "", "name": "", "user_id": ""]])).to(beNil())
            expect(Event.Body.MemberInvite(json: ["cname": "", "invited_by": "", "user": ["member_id": "", "name": "", "user_id": ""], "timestamp": ["": ""]])).to(beNil())
            expect(Event.Body.MemberInvite(json: ["cname": ""])).to(beNil())
            expect(Event.Body.MemberInvite(json: ["cname": "", "timestamp": ["invited": "2017-07-31T13:16:16.091Z"], "invited_by": "", "user": [:]])).to(beNil())
        }

        it("fails to create member invite user model") {
            expect(Event.Body.MemberInvite.User(json: [:])).to(beNil())
            expect(Event.Body.MemberInvite.User(json: ["user": ["": ""]])).to(beNil())
            expect(Event.Body.MemberInvite.User(json: ["user": ["member_id": ""]])).to(beNil())
            expect(Event.Body.MemberInvite.User(json: ["user": ["member_id": "", "user_id": ""]])).to(beNil())
        }
    }
}
