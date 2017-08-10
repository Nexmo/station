//
//  ImageEventTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 05/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class ImageEventTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("creates a image event with event model") {
            let event = Event(cid: "con-123", type: .text, memberId: "mem-123")
            let imageEvent = ImageEvent(conversationUuid: "con-123", event: event, seen: false)
            
            expect(imageEvent).toNot(beNil())
        }
        
        it("creates a image event with db event model") {
            let event = DBEvent(
                conversationUuid: "con-123",
                event: Event(cid: "con-123", type: .text, memberId: "mem-123"),
                seen: false
            )
            
            let imageEvent = ImageEvent(data: event)
            
            expect(imageEvent).toNot(beNil())
        }

        it("creates a image event with member") {
            let member = Member(
                conversationUuid: "con-123",
                member: MemberModel("mem-123", name: "test 1", state: .joined, userId: "usr-123", invitedBy: "demo1@nexmo.com", timestamp: [MemberModel.State.joined: Date()])
            )
            
            guard let image = UIImage(named: AssetsTest.nexmo.path, in: Bundle(for: type(of: self)), compatibleWith: nil) else { return fail() }
            guard let data = UIImageJPEGRepresentation(image, 0.75) else { return fail() }
            
            let imageEvent = ImageEvent(
                conversationUuid: "con-123",
                member: member,
                isDraft: false,
                distribution: [], 
                seen: false, 
                image: data
            )
            
            expect(imageEvent).toNot(beNil())
            expect(imageEvent.image).toNot(beNil())
        }
    }
}
