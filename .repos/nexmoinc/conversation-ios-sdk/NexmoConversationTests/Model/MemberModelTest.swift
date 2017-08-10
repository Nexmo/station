//
//  MemberTest.swift
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

internal class MemberModelTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        
        // MARK:
        // MARK: Test
        
        it("creating a member model") {
            let model = MemberModel(
                "id",
                name: "name",
                state: .joined,
                userId: "id",
                invitedBy: "demo1@nexmo.com",
                timestamp: [MemberModel.State.joined: Date()]
            )
            
            expect(model).toNot(beNil())
        }
        
        it("creating member object with json") {
            let json = self.json(path: .member)
            let member = MemberModel(json: json)
            
            expect(member).toNot(beNil())
            expect(member?.id.isEmpty) == false
        }

        it("creates a model with member json") {
            let json = self.json(path: .member)
            let member = MemberModel(json: json, state: .joined)

            expect(member).toNot(beNil())
            expect(member?.id.isEmpty) == false
        }

        it("fails to create member model") {
            expect(MemberModel(json: [:])).to(beNil())
            expect(MemberModel(json: ["member_id": ""])).to(beNil())
            expect(MemberModel(json: ["member_id": "", "name": ""])).to(beNil())
            expect(MemberModel(json: ["member_id": "", "name": "", "state": ""])).to(beNil())
            expect(MemberModel(json: ["member_id": "", "name": "", "state": "invited"])).to(beNil())
        }

        it("fails to create member model with state") {
            expect(MemberModel(json: [:], state: .joined)).to(beNil())
            expect(MemberModel(json: ["member_id": ""], state: .joined)).to(beNil())
            expect(MemberModel(json: ["member_id": "", "name": ""], state: .joined)).to(beNil())
        }

        it("matches int value for member state") {
            expect(MemberModel.State.joined.intValue) == 0
            expect(MemberModel.State.invited.intValue) == 1
            expect(MemberModel.State.left.intValue) == 2
        }

        it("fails matches int value for member state") {
            expect(MemberModel.State.joined.intValue) != 3
            expect(MemberModel.State.invited.intValue) != 2
            expect(MemberModel.State.left.intValue) != 1
        }

        it("returns member state from int value") {
            expect(MemberModel.State.from(0)).toNot(beNil())
            expect(MemberModel.State.from(1)).toNot(beNil())
            expect(MemberModel.State.from(2)).toNot(beNil())
        }

        it("fails to returns member state from int value") {
            expect(MemberModel.State.from(4)).to(beNil())
        }

        it("compares states") {
            expect(MemberModel.State.invited) == MemberModel.State.invited
            expect(MemberModel.State.joined) == MemberModel.State.joined
            expect(MemberModel.State.left) == MemberModel.State.left
        }

        it("compares member channel") {
            expect(MemberModel.Channel.app) == MemberModel.Channel.app
            expect(MemberModel.Channel.sip) == MemberModel.Channel.sip
            expect(MemberModel.Channel.pstn) == MemberModel.Channel.pstn
            expect(MemberModel.Channel.sms) == MemberModel.Channel.sms
            expect(MemberModel.Channel.ott) == MemberModel.Channel.ott
        }

        it("compares member action") {
            expect(MemberModel.Action.invite) == MemberModel.Action.invite
            expect(MemberModel.Action.join) == MemberModel.Action.join
        }

        it("fails to compare two member action") {
            expect(MemberModel.Action.invite) != MemberModel.Action.join
        }

        it("fails to compare two member states") {
            expect(MemberModel.State.joined) != MemberModel.State.invited
        }

        it("fails to compare two member channel") {
            expect(MemberModel.Channel.app) != MemberModel.Channel.ott
        }

        it("creates a member model with multiple timestamps") {
            let json = self.json(path: .memberWithMultipleTimestamps)
            let member = MemberModel(json: json)

            expect(member).toNot(beNil())
            expect(member?.id.isEmpty) == false
            expect(member?.date(of: .joined)).toNot(beNil())
            expect(member?.date(of: .invited)).toNot(beNil())
            expect(member?.date(of: .left)).toNot(beNil())
        }
    }
}
