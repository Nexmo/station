//
//  EventQueueTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 19/12/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
import RxTest
import RxTest
import RxBlocking
@testable import NexmoConversation

internal class EventQueueTest: QuickSpec {
    
    let observer = DatabaseObserver()
    let client = ConversationClient.instance
    let eventController = ConversationClient.instance.eventController
    let databaseManager = ConversationClient.instance.databaseManager
    let account = ConversationClient.instance.account
    let conversation = ConversationClient.instance.conversation
    let membershipController = ConversationClient.instance.membershipController
    let eventQueue = ConversationClient.instance.eventQueue
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        
        beforeEach {
            self.client.addAuthorization(with: "token")
        }
        
        afterEach {
        
        }
        
        // MARK:
        // MARK: Test
    
        it("adds a text event to be sent via worker thread") {
            let model = ConversationModel(uuid: "111", created: Date(), displayName: "display name", state: .joined, memberId: "mem-123")

            let conversation = Conversation(
                model,
                eventController: self.eventController,
                databaseManager: self.databaseManager,
                eventQueue: self.eventQueue,
                account: self.account,
                conversationController: self.conversation,
                membershipController: self.membershipController
            )
            
            _ = try? self.databaseManager.conversation.insert(conversation.data)
            
            let text = TextEvent(
                conversationUuid: "111",
                type: .text,
                member: Member(conversationUuid: "111", member: MemberModel("1", name: "1", state: .joined, userId: "1", invitedBy: "demo1@nexmo.com", timestamp: [MemberModel.State.joined: Date()])),
                seen: true
            )
            
            expect { try? self.client.eventQueue.add(.send, with: text) }.toNot(throwAssertion())
        }
        
        it("throws when adding a text event with max Id") {
            Database.default.queue.add(transactionObserver: self.observer)
            
            // remove cache to force a throw
            _ = self.observer.updatedTables.asObservable()
                .skip(1)
                .subscribe(onNext: { _ in self.client.objectCache.eventCache.clear() })

            let model = ConversationModel(uuid: "111", created: Date(), displayName: "display name", state: .joined, memberId: "mem-123")

            let conversation = Conversation(
                model,
                eventController: self.eventController,
                databaseManager: self.databaseManager,
                eventQueue: self.eventQueue,
                account: self.account,
                conversationController: self.conversation,
                membershipController: self.membershipController
            )
            
            expect {
                try? self.databaseManager.conversation.insert(conversation.data)
            }.toNot(throwAssertion())
            
            let text = TextEvent(
                conversationUuid: "",
                type: .text,
                member: Member(conversationUuid: "", member: MemberModel("2", name: "2", state: .joined, userId: "2", invitedBy: "demo1@nexmo.com", timestamp: [MemberModel.State.joined: Date()])),
                seen: true
            )
            
            expect { try? self.client.eventQueue.add(.send, with: text) }.to(throwAssertion())
        }
        
        it("sends a UI text event via a worker thread") {
            // parameter
            let event = SendEvent(
                conversationId: "con-1",
                from: "1",
                text: "hello from: \(Date())")

            let model = ConversationModel(uuid: "con-1", created: Date(), displayName: "display name", state: .joined, memberId: "mem-123")

            let conversation = Conversation(
                model,
                eventController: self.eventController,
                databaseManager: self.databaseManager,
                eventQueue: self.eventQueue,
                account: self.account,
                conversationController: self.conversation,
                membershipController: self.membershipController
            )

            let member = Member(conversationUuid: "con-1", member: MemberModel(
                "1",
                name: "1",
                state: .joined,
                userId: "usr-1",
                invitedBy: "demo1@nexmo.com",
                timestamp: [MemberModel.State.joined: Date()])
            )
            
            // stub
            self.stub(file: .sendImageMessage, request: EventRouter.send(event: event).urlRequest)
            
            expect { try? self.databaseManager.conversation.insert(conversation.data) }.toNot(throwAssertion())
            expect { try? self.databaseManager.member.insert(member.data) }.toNot(throwAssertion())
            
            let text = TextEvent(conversationUuid: "con-1", member: member, isDraft: true, distribution: [], seen: true, text: "test")
            
            var responseId: Int?
            
            expect {
                responseId = try SendEventOperation(text, eventController: self.client.eventController)
                    .perform()
                    .toBlocking()
                    .first()?.id
            }.toNot(throwError())
            
            expect(responseId).toEventually(equal(389))
        }
        
        it("sends a failing UI text event via a worker thread") {
            // parameter
            let event = SendEvent(
                conversationId: "con-1",
                from: "1",
                text: "hello from: \(Date())")

            let model = ConversationModel(uuid: "111", created: Date(), displayName: "display name", state: .joined, memberId: "mem-123")

            let conversation = Conversation(
                model,
                eventController: self.eventController,
                databaseManager: self.databaseManager,
                eventQueue: self.eventQueue,
                account: self.account,
                conversationController: self.conversation,
                membershipController: self.membershipController
            )

            let member = Member(conversationUuid: "con-1", member: MemberModel("1", name: "1", state: .joined, userId: "1", invitedBy: "demo1@nexmo.com", timestamp: [MemberModel.State.joined: Date()]))
            
            // stub
            self.stubClientError(request: EventRouter.send(event: event).urlRequest)
            
            expect { try? self.databaseManager.conversation.insert(conversation.data) }.toNot(throwAssertion())
            expect { try? self.databaseManager.member.insert(member.data) }.toNot(throwAssertion())
            
            let text = TextEvent(conversationUuid: "con-1", member: member, isDraft: true, distribution: [], seen: true, text: "test")
            
            expect {
                try SendEventOperation(text, eventController: self.client.eventController)
                    .perform()
                    .toBlocking()
                    .first()?.id
            }.to(throwError())
        }
        
        it("sends a UI image event via a worker thread") {
            self.client.addAuthorization(with: "token")
            
            guard let body = UploadedImage(json: self.json(path: JSONTest.uploadedImage))?.toJSON() else { return fail() }
            guard let image = UIImage(named: AssetsTest.nexmo.path, in: Bundle(for: type(of: self)), compatibleWith: nil) else { return fail() }
            guard let data = UIImageJPEGRepresentation(image, 0.75) else { return fail() }
            
            // parameter
            let event = SendEvent(
                conversationId: "con-1",
                from: "1",
                representations: body
            )
            
            let member = Member(conversationUuid: "con-1", member: MemberModel("1", name: "1", state: .joined, userId: "1", invitedBy: "demo1@nexmo.com", timestamp: [MemberModel.State.joined: Date()]))

            // stub
            self.stub(file: .uploadedImage, request: IPSRouter.upload().urlRequest)
            self.stub(file: .sendImageMessage, request: EventRouter.send(event: event).urlRequest)

            let imageEvent = ImageEvent(
                conversationUuid: "con-1",
                member: member,
                isDraft: true,
                distribution: [],
                seen: false,
                image: data
            )
            
            var responseId: Int?
            
            expect {
                responseId = try SendEventOperation(imageEvent, eventController: self.client.eventController)
                    .perform()
                    .toBlocking()
                    .first()?.id
            }.toNot(throwError())
            
            expect(responseId).toEventually(equal(389))
        }
        
        it("throws when sending a image without data") {
            // parameter
            let member = Member(conversationUuid: "1", member: MemberModel("1", name: "1", state: .joined, userId: "1", invitedBy: "demo1@nexmo.com", timestamp: [MemberModel.State.joined: Date()]))
            let event = ImageEvent(conversationUuid: "1", member: member, isDraft: true, distribution: [], seen: false)
            
            expect {
                try SendEventOperation(event, eventController: self.client.eventController).perform()
            }.to(throwError())
        }
        
        it("fails to send a image due to network issue") {
            self.client.addAuthorization(with: "token")
            
            let mock = SimpleMockDatabase()
            
            guard let image = UIImage(named: AssetsTest.nexmo.path, in: Bundle(for: type(of: self)), compatibleWith: nil) else {
                return fail()
            }
            
            guard let data = UIImageJPEGRepresentation(image, 0.75) else { return fail() }
            
            // stub
            self.stubServerError(request: IPSRouter.upload().urlRequest)
            
            let event = ImageEvent(
                conversationUuid: mock.conversation1.rest.uuid,
                member: Member(data: mock.DBMember1),
                isDraft: true,
                distribution: [],
                seen: false,
                image: data
            )
            
            expect {
                try SendEventOperation(event, eventController: self.client.eventController)
                    .perform()
                    .toBlocking()
                    .first()?.id
            }.to(throwError())
        }
    }
}
