//  Conversation.swift
//  NexmoConversation
//
//  Created by James Green on 26/08/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import RxSwift

/// Conversation Facade Object
@objc(NXMConversation)
public class Conversation: NSObject {

    // MARK:
    // MARK: Enum
    
    /// Changes to event observer
    ///
    /// - reset: reset all events
    /// - inserts: inserted events at indexpath
    /// - deletes: deleted events at indexpath
    /// - updates: updated events at indexpath
    /// - move: moved events from and to
    /// - beginBatchEditing: begin batch editing
    /// - endBatchEditing: end batch editing
    public enum Change {
        case reset
        case inserts([IndexPath])
        case deletes([IndexPath])
        case updates([IndexPath])
        case move(IndexPath, IndexPath)
        case beginBatchEditing
        case endBatchEditing
    }
    
    /// Error
    ///
    /// - eventBodyIsEmpty: event could not be found in cache or database
    /// - cannotProcessRequest: cannot process request
    public enum Errors: Error, Equatable {
        case eventBodyIsEmpty
        case cannotProcessRequest
        case memberNotFound
    }
    
    // MARK:
    // MARK: Properties
    
    internal var data: DBConversation

    /// UUID identifying this conversation.
    public var uuid: String { return data.rest.uuid }
    
    /// Conversation name
    public var name: String {
        if !data.rest.displayName.isEmpty {
            return data.rest.displayName
        } else {
            return data.rest.name
        }
    }
    
    /**
     An array of all of the users in the conversation.
     
     ```
     var users:[Users] = conversation.allUsers
     ```
     
     */
    public var users: [User] { return members.allUsers }
    
    /// Last event number 
    public var lastSequence: Int { return data.rest.sequenceNumber }
    
    /**
     A collection of all of the members in the conversation.
     
     ```
     var members: NexmoConversation.LazyCollection<Member>  = conversation.allMembers
     ```
     
     */
    public let members: MemberCollection
    
    /// All events in this conversation.
    public private(set) var allEvents: EventCollection
    
    /**
     The state of the user in this conversation.  Can be any of the states in Member.State
     
     ```
     var state: Member.State = conversation.state
     ```
     
     */
    public var state: MemberModel.State {
        let memberships = membershipForUser(user: account.user!)
        
        return memberships.last!.state
    }
    
    /**
     Date conversation was created
     */
    public var creationDate: Date { return data.rest.created }

    // this method will find the last of our joined members, and use the last unjoined member if no joined member exists
    // Hopefully user will only have one joined member!
    internal var ourMemberRecord: Member? {
        guard let me = account.user else { return nil }
        
        let members = membershipForUser(user: me)
        let membership1 = members.filter { $0.state == .joined }.last
        let membership2 = members.last
        
        return membership1 ?? membership2
    }
    
    internal var ourMemberRecords: [Member] {
        if let me = self.account.user {
            return membershipForUser(user: me)
        }
        
        return []
    }
    
    private let eventQueue: EventQueue
    private let eventController: EventController
    private let account: AccountController
    internal let controller: ConversationController
    internal let membershipController: MembershipController
    private let databaseManager: DatabaseManager
    
    /// Rx
    internal let disposeBag = DisposeBag()
    
    // MARK:
    // MARK: Properties - Observable
    
    /**
     
     Signal for when conversation name changes.
     
     Can add handlers to respond to changes in conversation name.
     
     Using selectors:
     
     ```
     nameChanged.addHandler(self, selector: #selector(MyClass.handleNameChange))
     ```
     
     Using swift handlers:
     
     ```
     nameChanged.addHandler(self, handler: MyClass.handleNameChange)
     ```
     
     Handler should have Conversation and 2 Strings (old and new names) as parameters:
     
     ```
     func handleNameChange(conversation: Conversation, oldName: String, newName:String) {
     
     // Do something here
     
     }
     ```
     */
    public let nameChanged = Signal<(old: String?, new: String?)>()
    
    /**
     
     Signal for when new event is received.
     
     Can add handlers to respond to new events in this conversation
     
     Using selectors:
     
     ```
     newEventReceived.addHandler(self, selector: #selector(MyClass.handleNewEvent))
     ```
     
     Using swift handlers:
     
     ```
     newEventReceived.addHandler(self, handler: MyClass.handleNewEvent)
     ```
     
     Handler should have Conversation and EventBase as parameters:
     
     ```
     func handleNewEvent(conversation: Conversation, newEvent: EventBase) {
     
     // Do something here
     
     }
     ```
     */
    public let newEventReceived = Signal<EventBase>()
    
    /**
     
     Signal for when new member is added to the conversation
     
     Can add handlers to respond to new members in this conversation
     
     Using selectors:
     
     ```
     newMember.addHandler(self, selector: #selector(MyClass.handleNewMember))
     ```
     
     Using swift handlers:
     
     ```
     newMember.addHandler(self, handler: MyClass.handleNewMember)
     ```
     
     Handler should have Conversation and Member as parameters:
     
     ```
     func handleNewMember(conversation: Conversation, newMember: Member) {
     
     // Do something here
     
     }
     ```
     */
    public let newMember = Signal<Member>()
    
    /**
     
     Signal for when a member left the conversation
     
     Can add handlers to respond to a member leaving this conversation
     
     Using selectors:
     
     ```
     memberLeft.addHandler(self, selector: #selector(MyClass.handleMemberLeft))
     ```
     
     Using swift handlers:
     
     ```
     memberLeft.addHandler(self, handler: MyClass.handleMemberLeft)
     ```
     
     Handler should have Conversation and Member as parameters:
     
     ```
     func handleMemberLeft(conversation: Conversation, member: Member) {
     
     // Do something here
     
     }
     ```
     */
    public let memberLeft = Signal<Member>()

    /**
     
     Signal for when a member joined the conversation
     
     Can add handlers to respond to a member joining this conversation
     
     Using selectors:
     
     ```
     memberJoined.addHandler(self, selector: #selector(MyClass.handleMemberJoined))
     ```
     
     Using swift handlers:
     
     ```
     memberJoined.addHandler(self, handler: MyClass.handleMemberJoined)
     ```
     
     Handler should have Conversation and Member as parameters:
     
     ```
     func handleMemberJoined(conversation: Conversation, member: Member) {
     
     // Do something here
     
     }
     ```
     */
    public let memberJoined = Signal<Member>()

    /**
     
     Signal for when a member is invited to the conversation
     
     Can add handlers to respond to a member being invited to this conversation
     
     Using selectors:
     
     ```
     memberInvited.addHandler(self, selector: #selector(MyClass.handleMemberInvited))
     ```
     
     Using swift handlers:
     
     ```
     memberInvited.addHandler(self, handler: MyClass.handleMemberInvited)
     ```
     
     Handler should have Conversation and Member as parameters:
     
     ```
     func handleMemberInvited(conversation: Conversation, member: Member) {
     
     // Do something here
     
     }
     ```
     */
    public let memberInvited = Signal<Member>()
  
    /**
     
     Signal for when the members in this conversation change
     
     Can add handlers to respond to a change in the members in this conversation
     
     Using selectors:
     
     ```
     membersChanged.addHandler(self, selector: #selector(MyClass.handleMembersChanged))
     ```
     
     Using swift handlers:
     
     ```
     membersChanged.addHandler(self, handler: MyClass.handleMembersChanged)
     ```
     
     Handler should have Conversation as a parameter:
     
     ```
     func handleMembersChanged(conversation: Conversation) {
     
     // Do something here
     
     }
     ```
     */
    public let membersChanged = Signal<Void>()

    /**
     
     Signal for when a text event is sent
     
     Can add handlers to respond to sending a text 
     
     Using selectors:
     
     ```
     messageSent.addHandler(self, selector: #selector(MyClass.handleMessageSent))
     ```
     
     Using swift handlers:
     
     ```
     messageSent.addHandler(self, handler: MyClass.handleMessageSent)
     ```
     
     Handler should have Conversation and TextEvent as parameters:
     
     ```
     func handleMessageSent(conversation: Conversation, textEvent: TextEvent) {
     
     // Do something here
     
     }
     ```
     */
    public let messageSent = Signal<TextEvent>()
    
    /// Notification of deleted event
    /// Returns event and type of changes that where made
    public let events = Signal<(events: [EventBase], change: Change)>()
    
    // MARK:
    // MARK: NSObject
    
    /// Hashable
    public override var hashValue: Int { return data.rest.uuid.hashValue }
    
    /// Description
    public override var description: String { return "uuid:" + data.rest.uuid + ", " + self.name }
    
    // MARK:
    // MARK: Initializers
    
    internal init(_ conversation: DBConversation,
                  eventController: EventController,
                  databaseManager: DatabaseManager,
                  eventQueue: EventQueue,
                  account: AccountController,
                  conversationController: ConversationController,
                  membershipController: MembershipController) {
        data = conversation
        members = MemberCollection(conversationUuid: self.data.rest.uuid, databaseManager: databaseManager)
        allEvents = EventCollection(conversationUuid: self.data.rest.uuid, databaseManager: databaseManager)
        controller = conversationController
        self.eventController = eventController
        self.databaseManager = databaseManager
        self.eventQueue = eventQueue
        self.account = account
        self.membershipController = membershipController
        
        super.init()
        
        setup()
    }
    
    internal init(_ conversation: ConversationModel,
                  eventController: EventController,
                  databaseManager: DatabaseManager,
                  eventQueue: EventQueue,
                  account: AccountController,
                  conversationController: ConversationController,
                  membershipController: MembershipController) {
        data = DBConversation(conversation: conversation)
        members = MemberCollection(conversationUuid: self.data.rest.uuid, databaseManager: databaseManager)
        allEvents = EventCollection(conversationUuid: self.data.rest.uuid, databaseManager: databaseManager)
        controller = conversationController
        self.eventController = eventController
        self.databaseManager = databaseManager
        self.eventQueue = eventQueue
        self.account = account
        self.membershipController = membershipController
        
        super.init()
        
        setup()
    }
    
    // MARK:
    // MARK: Setup
    
    private func setup() {

    }
    
    // MARK:
    // MARK: Event
    
    /// Send text event
    ///
    /// - Parameter text: text
    /// - throws: error if task cannot be added to queue or event is empty
    @objc(sendText:error:)
    public func send(_ text: String) throws {
        guard text.isEmpty == false else { throw Errors.eventBodyIsEmpty }
        guard let member = ourMemberRecord else { throw Errors.cannotProcessRequest }

        let event = TextEvent(conversationUuid: uuid, member: member, isDraft: true, distribution: members.uuids, seen: true, text: text)
                
        try send(event)
    }
    
    /// Send image event
    ///
    /// - Parameter image: raw image, use UIImagePNGRepresentation or UIImageJPEGRepresentation 
    /// - throws: error if task cannot be added to queue or event is empty
    @objc(sendImage:error:)
    public func send(_ image: Data) throws {
        guard let member = ourMemberRecord else { throw Errors.cannotProcessRequest }

        let event = ImageEvent(
            conversationUuid: uuid,
            member: member,
            isDraft: true,
            distribution: members.uuids,
            seen: true,
            image: image
        )
        
        try send(event)
    }
    
    /// Send event
    ///
    /// - parameter event: event
    ///
    /// - throws: error if task cannot be added to queue or event is empty
    public func send(_ event: TextEvent) throws {
        try eventQueue.add(.send, with: event)
    }
    
    /// Delete event
    ///
    /// - Parameter event: event to delete
    /// - Returns: if event is scheduled to be deleted
    @discardableResult
    public func delete(_ event: TextEvent) -> Bool {
        guard event.from.isMe else { return false }
        
        do {
            try eventQueue.add(.delete, with: event)
            
            return true
        } catch {
            return false
        }
    }
    
    // MARK:
    // MARK: Membership
    
    /// Memberships for User
    ///
    /// A user can have more than one membership in a conversation if they have left a conversation and then rejoined.
    ///
    /// - parameter user: the user whose memberships you want
    ///
    /// - returns: An array of members for this user in this conversation
    public func membershipForUser(user: User) -> [Member] {
        return members.membershipForUser(user: user)
    }
    
    /// Join this conversatation
    ///
    /// - returns: an operation which joins the user to the conversation
    public func join() -> Single<Void> {
        guard case .loggedIn(let session) = account.state.value else {
            return Single<Void>.error(ConversationClient.Errors.userNotInCorrectState)
        }

        return controller.join(ConversationController.JoinConversation(userId: session.userId, memberId: ourMemberRecord?.uuid), forUUID: uuid)
            .do(onError: { [weak self] _ in self?.members.refresh() })
            .observeOnMainThread()
            .flatMap { _ in Observable<Void>.just(()) }
            .asSingle()
    }
    
    /// Leave this conversation
    ///
    /// - returns: an operation which removes the user from the conversation and can be used to cancel the request
    public func leave() -> Single<Void> {
        guard let member = ourMemberRecord else { return Single.error(Errors.memberNotFound) }
            
        return member.kick()
    }

    /// Invite someone to this conversation
    ///
    /// - return: Completion of inviting a member to the conversation
    public func invite(_ username: String) -> Single<Void> {
        return membershipController.invite(user: username, for: uuid)
            .observeOnMainThread()
            .asSingle()
    }
    
    // MARK:
    // MARK: Indicator
    
    /// Indicate user is trying
    ///
    /// - returns: result of request was sent
    @discardableResult
    public func startTyping() -> Bool {
        return setTypingStatus(true)
    }
    
    /// Indicate user has stopped trying
    ///
    /// - returns: result of request was sent
    @discardableResult
    public func stopTyping() -> Bool {
        return setTypingStatus(false)
    }
    
    /// Start/Stop typing
    ///
    /// - returns: result of request was sent
    @discardableResult
    private func setTypingStatus(_ isTyping: Bool) -> Bool {
        guard let memberId = ourMemberRecord?.uuid else { return false }
        let event = SendEvent(conversationId: uuid, from: memberId, isTyping: isTyping)
        
        eventController.send(event)
            .subscribe()
            .addDisposableTo(disposeBag)
        
        return true
    }
    
    // MARK:
    // MARK: Refresh

    internal func refreshMemberCollection() {
        members.refresh()
    }
    
    internal func refreshAllEventsList() {
        self.allEvents = EventCollection(conversationUuid: self.data.rest.uuid, databaseManager: databaseManager)
    }
    
    internal func updateWithNewData(new: DBConversation) -> (/* Updates made */Bool, /* events */ SignalInvocations) {
        var updatesMade = false
        let events: SignalInvocations = SignalInvocations()
        
        var name = self.data.rest.name
        
        /* Look for updates. */
        SignalInvocations.compareField(
            current: &name,
            new: new.rest.name,
            updatesMade: &updatesMade,
            signals: events,
            signal: { current, new in
                self.nameChanged.emit((current, new))
            }
        )

        return (updatesMade, events)
    }
}

// MARK:
// MARK: Compare

/// Compare wherever conversation is the same
///
/// - Parameters:
///   - lhs: conversation
///   - rhs: conversation
/// - Returns: result
public func ==(lhs: Conversation, rhs: Conversation) -> Bool {
    return lhs.data.rest.uuid == rhs.data.rest.uuid
}

/// Compare Errors
public func ==(lhs: Conversation.Errors, rhs: Conversation.Errors) -> Bool {
    switch (lhs, rhs) {
    case (.eventBodyIsEmpty, .eventBodyIsEmpty): return true
    case (.cannotProcessRequest, .cannotProcessRequest): return true
    case (.memberNotFound, .memberNotFound): return true
    case (.memberNotFound, _),
         (.eventBodyIsEmpty, _),
         (.cannotProcessRequest, _): return false
    }
}
