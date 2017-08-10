//
//  MemberTest.swift
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

internal class MemberTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    let dao = EventDAO(database: Database.default)
    let mock = SimpleMockDatabase()
    
    override func spec() {
        
        // MARK:
        // MARK: Test
        
        it("kicks myself out of a conversation") {
            self.stubOk(with: MembershipRouter.kick(conversationId: "con-1", memberId: "mem-1").urlRequest)
            
            let client = ConversationClient.instance
            
            DatabaseFactory.saveConversation(with: client)
            
            let conversation = client.conversation.conversations.first
            
            var result: Bool = false
            
            _ = conversation?.members.first?.kick().subscribe(onSuccess: { _ in
                result = true
            }, onError: { _ in
                fail()
            })
            
            expect(result).toEventually(beTrue())
        }
        
        it("fails to kicks myself out of a conversation") {
            self.stubClientError(request: MembershipRouter.kick(conversationId: "con-1", memberId: "mem-1").urlRequest)
            
            let client = ConversationClient.instance
            
            DatabaseFactory.saveConversation(with: client)
            
            let conversation = client.conversation.conversations.first
            
            var error: Error?
            
            _ = conversation?.members.first?.kick().subscribe(onSuccess: { _ in
                fail()
            }, onError: { newError in
                error = newError
            })
            
            expect(error).toEventuallyNot(beNil())
        }
        
        it("compares both member are the same") {
            let client = ConversationClient.instance
            
            DatabaseFactory.saveConversation(with: client)
            
            guard let member1 = client.conversation.conversations.first?.members.first else { return fail() }
            guard let member2 = client.conversation.conversations.first?.members.first else { return fail() }
            
            let result = member1 == member2
            
            expect(result) == true
            expect(member1.description.isEmpty) == false
            expect(member1.hashValue) > 1
            expect(member1.user.uuid.isEmpty) == false
        }
        
        it("compares both member are not the same") {
            let client = ConversationClient.instance
            
            DatabaseFactory.saveConversation(with: client)
            
            guard let member1 = client.conversation.conversations.first?.members.first else { return fail() }
            let member2 = client.conversation.conversations.first?.members[1] 
            
            let result = member1 == member2
            
            expect(result) == false
        }
        
        it("creates a model from rest") {
            let member = Member(conversationUuid: "con-1", member: SimpleMockDatabase().member1)
            
            expect(member.uuid) == "mem-1"
        }
        
        it("creates a model from db record") {
            let member = Member(data: SimpleMockDatabase().DBMember1)
            
            expect(member.uuid) == "mem-1"
        }
        
        it("joined member has nil timestamp if no joined event") {
            let client = ConversationClient.instance
            
            DatabaseFactory.saveConversation(with: client)
            
            guard let conversation = client.conversation.conversations.first, let member1 = conversation.members.first else { return fail() }
            
            // expect member to have userid
            expect(member1.user.uuid.isEmpty) == false
            
            let timestampJoined = member1.date(of: MemberModel.State.invited)
            expect(timestampJoined).toEventually(beNil())
        }
        
        it("joined member has timestamp for joined event") {
            let client = ConversationClient.instance
            
            DatabaseFactory.saveConversation(with: client)
            
            guard let conversation = client.conversation.conversations.first, let member1 = conversation.members.first else { return fail() }
            
            // insert joined event
            let event = self.mock.DBEvent4
            expect { try self.dao.insert(event) }.toNot(throwAssertion())
            
            // refresh events collection in conversation
            conversation.refreshAllEventsList()
            
            // expect member to have userid and the conversation to have events collection
            expect(member1.user.uuid.isEmpty) == false
            expect(conversation.allEvents.count) > 0
            
            let timestampJoined = member1.date(of: MemberModel.State.joined)
            expect(timestampJoined).toEventuallyNot(beNil())
        }
    }
}
