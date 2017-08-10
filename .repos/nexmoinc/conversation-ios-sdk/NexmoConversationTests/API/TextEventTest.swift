//
//  TextEventTest.swift
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

internal class TextEventTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("creates a event type of text") {
            let event = Event(cid: "con-123", type: .text, memberId: "mem-123")
            let textEvent = TextEvent(conversationUuid: "con-123", event: event, seen: false)
            
            expect(textEvent).toNot(beNil())
        }
        
        it("creates a text event with db event") {
            let event = DBEvent(
                conversationUuid: "con-123",
                event: Event(cid: "con-123", type: .text, memberId: "mem-123"),
                seen: false
            )
            
            let textEvent = TextEvent(data: event)
            
            expect(textEvent.data.cid) == event.cid
        }
        
        it("creates a text event with member") {
            let member = Member(
                conversationUuid: "con-123",
                member: MemberModel("mem-123", name: "test 1", state: .joined, userId: "usr-123", invitedBy: "demo1@nexmo.com", timestamp: [MemberModel.State.joined: Date()])
            )
            
            let textEvent = TextEvent(conversationUuid: "con-123", type: .text, member: member, seen: false)
            
            expect(textEvent).toNot(beNil())
        }

        it("creates a draft text event") {
            let member = Member(
                conversationUuid: "con-123",
                member: MemberModel("mem-123", name: "test 1", state: .joined, userId: "usr-123", invitedBy: "demo1@nexmo.com", timestamp: [MemberModel.State.joined: Date()])
            )
            
            let textEvent = TextEvent(conversationUuid: "con-123", member: member, isDraft: true, distribution: [], seen: false, text: "")
            
            expect(textEvent.data.isDraft) == true
        }
        
        it("not currently been sent") {
            let event = Event(cid: "con-123", type: .text, memberId: "mem-123")
            let textEvent = TextEvent(conversationUuid: "con-123", event: event, seen: false)
            
            expect(textEvent.isCurrentlyBeingSent) == false
        }
        
        it("has a valid conversation uuid") {
            let event = Event(cid: "con-123", type: .text, memberId: "mem-123")
            let textEvent = TextEvent(conversationUuid: "con-123", event: event, seen: false)
            
            expect(textEvent.uuid) == "con-123:0"
        }
        
        it("has a real conversation in the db linked a text event") {
            _ = ConversationClient.instance
            
            let mock = SimpleMockDatabase()
            
            let textEvent = TextEvent(conversationUuid: mock.conversation1.rest.uuid, event: mock.event1, seen: false)
                
            expect(textEvent.conversation).toNot(beNil())
        }
        
        it("delete own event fails") {
            let client = ConversationClient.instance
            
            let mock = SimpleMockDatabase()
            
            let textEvent = TextEvent(conversationUuid: mock.conversation1.rest.uuid, event: mock.event1, seen: false)
            
            do {
                try client.databaseManager.event.deleteAll()
                try client.databaseManager.event.insert(textEvent.data)
                
                expect(textEvent.delete()) == false
            } catch {
                fail()
            }
        }
    }
}
