//
//  SimpleMockDatabase.swift
//  NexmoConversation
//
//  Created by shams ahmed on 09/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
@testable import NexmoConversation

/// Lite weight mock database
internal struct SimpleMockDatabase {
    
    // MARK:
    // MARK: Members
    
    let user1 = DBUser(data: UserModel(displayName: "user 1", imageUrl: "http://nexmo.com/user1.jpeg", uuid: "usr-1", name: "user 1"))
    let user2 = DBUser(data: UserModel(displayName: "user 2", imageUrl: "http://nexmo.com/user2.jpeg", uuid: "usr-2", name: "user 2"))
    let user3 = DBUser(data: UserModel(displayName: "user 3", imageUrl: "http://nexmo.com/user2.jpeg", uuid: "usr-3", name: "user 3"))

    let member1 = MemberModel("mem-1", name: "user 1", state: .joined, userId: "usr-1", invitedBy: "demo1@nexmo.com", timestamp: [MemberModel.State.joined: Date()])
    let member2 = MemberModel("mem-2", name: "user 2", state: .joined, userId: "usr-2", invitedBy: "demo1@nexmo.com", timestamp: [MemberModel.State.joined: Date()])
    let member3 = MemberModel("mem-123", name: "user 3", state: .joined, userId: "usr-3", invitedBy: "demo1@nexmo.com", timestamp: [MemberModel.State.joined: Date()])
    
    var DBMember1: DBMember { return DBMember(conversationUuid: "con-1", member: member1) }
    var DBMember2: DBMember { return DBMember(conversationUuid: "con-1", member: member2) }
    var DBMember3: DBMember { return DBMember(conversationUuid: "con-1", member: member3) }
    
    // MARK:
    // MARK: Conversation
    
    var conversation1: DBConversation {
        return DBConversation(conversation: ConversationModel(uuid: "con-1", name: "conversation 1", sequenceNumber: 1, members: [member1, member2], created: Date(), displayName: "conversation 1", state: .joined, memberId: "mem-123"))
    }
    
    var conversation2: DBConversation {
        return DBConversation(conversation: ConversationModel(uuid: "con-2", name: "conversation 2", sequenceNumber: 2, members: [member2, member3], created: Date(), displayName: "conversation 2", state: .joined, memberId: "mem-2"))
    }
    
    // MARK:
    // MARK: Event
    
    var event1: Event {
        guard let date: Date = DateFormatter.ISO8601?.date(from: "2017-01-01T09:27:14.875Z") else { fatalError() }
        
        let event = Event(cid: conversation1.rest.uuid, id: 1, from: member1.id, to: nil, timestamp: date, type: .text)
        event.body = ["text": "event 1"]
        
        return event
    }
    
    var event2: Event {
        guard let date: Date = DateFormatter.ISO8601?.date(from: "2017-01-01T10:21:14.875Z") else { fatalError() }
        
        let event = Event(cid: conversation1.rest.uuid, id: 2, from: member2.id, to: nil, timestamp: date, type: .text)
        event.body = ["text": "event 2"]
        
        return event
    }
    
    var event3: Event {
        guard let date: Date = DateFormatter.ISO8601?.date(from: "2017-01-01T11:12:14.875Z") else { fatalError() }
        
        let event = Event(cid: conversation1.rest.uuid, id: 3, from: member1.id, to: nil, timestamp: date, type: .text)
        event.body = ["text": "event 3"]
        
        return event
    }
    
    var event4: Event {
        guard let date: Date = DateFormatter.ISO8601?.date(from: "2017-01-01T11:12:14.875Z") else { fatalError() }
        
        let event = Event(cid: conversation1.rest.uuid, id: 4, from: member1.id, to: nil, timestamp: date, type: .memberJoined)
        
        let joinedDictionary = [
            "timestamp": ["joined": "2017-01-01T11:12:14.875Z"],
            "user": ["user_id": member1.userId, "name": member1.name]
        ]
        
        event.body = joinedDictionary
        
        return event
    }
    
    var DBEvent1: DBEvent {
        let event = DBEvent(conversationUuid: conversation1.rest.uuid, event: event1, seen: true)
        
        return event
    }
    
    var DBEvent2: DBEvent {
        let event = DBEvent(conversationUuid: conversation1.rest.uuid, event: event2, seen: true)
        
        return event
    }
    
    var DBEvent3: DBEvent {
        let event = DBEvent(conversationUuid: conversation1.rest.uuid, event: event3, seen: false)
        
        return event
    }
    
    var DBEvent4: DBEvent {
        let event = DBEvent(conversationUuid: conversation1.rest.uuid, event: event4, seen: false)
        
        return event
    }
    
    // MARK:
    // MARK: Receipt
    
    var receipt1: DBReceipt {
        return DBReceipt(conversationId: conversation1.rest.uuid, memberId: DBMember1.rest.userId, eventId: DBEvent1.id)
    }
    
    var receipt2: DBReceipt {
        return DBReceipt(conversationId: conversation1.rest.uuid, memberId: DBMember1.rest.userId, eventId: DBEvent2.id)
    }
    
    // MARK:
    // MARK: Initializers
    
    init() {
        setup()
    }
    
    // MARK:
    // MARK: Setup
    
    private func setup() {
        do {
            try ConversationClient.instance.databaseManager.user.insert(user1)
            try ConversationClient.instance.databaseManager.user.insert(user2)
            try ConversationClient.instance.databaseManager.user.insert(user3)
            try ConversationClient.instance.databaseManager.member.insert(DBMember1)
            try ConversationClient.instance.databaseManager.member.insert(DBMember2)
            try ConversationClient.instance.databaseManager.member.insert(DBMember3)
            try ConversationClient.instance.databaseManager.receipt.insert(receipt1)
            try ConversationClient.instance.databaseManager.receipt.insert(receipt2)
            
            let conversation1 = Conversation(self.conversation1,
                                               eventController: ConversationClient.instance.eventController,
                                               databaseManager: ConversationClient.instance.databaseManager,
                                               eventQueue: ConversationClient.instance.eventQueue,
                                               account: ConversationClient.instance.account,
                                               conversationController: ConversationClient.instance.conversation,
                                               membershipController: ConversationClient.instance.membershipController
            )
            
            let conversation2 = Conversation(self.conversation2,
                                             eventController: ConversationClient.instance.eventController,
                                             databaseManager: ConversationClient.instance.databaseManager,
                                             eventQueue: ConversationClient.instance.eventQueue,
                                             account: ConversationClient.instance.account,
                                             conversationController: ConversationClient.instance.conversation,
                                             membershipController: ConversationClient.instance.membershipController
            )
            
            try ConversationClient.instance.databaseManager.conversation.insert(conversation1.data)
            try ConversationClient.instance.databaseManager.conversation.insert(conversation2.data)
        } catch {
            fatalError()
        }
    }
}
