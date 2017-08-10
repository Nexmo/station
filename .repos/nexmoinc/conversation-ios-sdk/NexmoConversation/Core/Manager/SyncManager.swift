//
//  SyncManager.swift
//  NexmoConversation
//
//  Created by James Green on 22/08/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import RxSwift
// TODO: remove Gloss import, sync manager does not need to know about json etc..
import Gloss

/// Compare sync state
///
/// - Parameters:
///   - lhs: lhs state
///   - rhs: rhs state
/// - Returns: result of comparison
public func ==(lhs: SynchronizingState, rhs: SynchronizingState) -> Bool {
    switch (lhs, rhs) {
    case (.conversations, .conversations): return true
    case (.events, .events): return true
    case (.members, .members): return true
    case (.users, .users): return true
    case (.receipts, .receipts): return true
    case (.tasks, .tasks): return true
    case (.conversations, _),
         (.events, _),
         (.members, _),
         (.users, _),
         (.receipts, _),
         (.tasks, _): return false
    }
}

internal func ==(lhs: SyncManager.State, rhs: SyncManager.State) -> Bool {
    switch (lhs, rhs) {
    case (.inactive, .inactive): return false
    case (.failed, .failed): return false
    case (.active(let l), .active(let r)): return l == r
    case (.inactive, _),
         (.failed, _),
         (.active, _): return false
    }
}

/// State of synchronizing
///
/// - conversations: processing conversations
/// - events: processing events
/// - members: processing members
/// - users: processing users
/// - receipt: processing receipts
/// - tasks: sending all unsent request i.e events
public enum SynchronizingState: String {
    case conversations
    case events
    case members
    case users
    case receipts
    case tasks
}

// TODO: rename to Syncer
internal class SyncManager {
    
    internal typealias EventQueueItem = (Conversation?, Event)
    internal typealias SyncManagerUserSyncCallback = (User?) -> Void
    
    /// Queue status
    ///
    /// - active: Queue has active jobs
    /// - inactive: Queue is ready to be used
    /// - failed: Queue failed to start up and sync 
    internal enum State: Equatable {
        case active(SynchronizingState)
        case inactive
        case failed
    }
    
    /// State of queue
    internal var state: Variable<State> = Variable<State>(.inactive)
    
    private var workerThread: Thread? // Our worker thread.

    private var queue: [EventQueueItem] = [] // Queue of events (received via web sockets) for us to process.
    private var usersRequiringSync: [(String, SyncManagerUserSyncCallback)] = []
    private var syncWorkerCondition = NSCondition() // Semaphore for flagging updates to the event queue.
    
    private let conversationController: ConversationController
    private let account: AccountController
    private let eventController: EventController
    private let membershipController: MembershipController
    private let objectCache: CacheManager
    private let databaseManager: DatabaseManager
    private let eventQueue: EventQueue

    /// Sync should keep running while active
    private var active = false

    /// TODO: Remove after refactoring on sync manager, holds all conversations which cannot be fetched from network
    /// with current codebse it not possible to stop the sync
    private var failedSyncedConversation = Set<ConversationPreviewModel>()
    
    /// Rx
    private let disposeBag = DisposeBag()
    
    // MARK:
    // MARK: Initializers 
    
    internal init(conversation: ConversationController,
                  account: AccountController,
                  eventController: EventController,
                  membershipController: MembershipController,
                  cache: CacheManager,
                  databaseManager: DatabaseManager,
                  eventQueue: EventQueue) {
        self.conversationController = conversation
        self.account = account
        self.eventController = eventController
        self.databaseManager = databaseManager
        self.eventQueue = eventQueue
        self.membershipController = membershipController
        
        objectCache = cache
    }

    // MARK:
    // MARK: Connect/Disconnect

    internal func start() {
        active = true
        
        // ensure we have only have one worker thread. start() is called when socket state becomes 'connected', so if we reconnect we find ourselves in here again
        guard workerThread == nil else { return }
    
        workerThread = Thread(target: self, selector: #selector(SyncManager.worker(param:)), object: nil)
        workerThread?.start()
    }
    
    internal func close() {
        workerThread?.cancel()
    }
    
    // MARK:
    // MARK: Worker

    @objc
    private func worker(param: NSObject) {
        defer {
            workerThread = nil
        }
        
        // TODO: remove while(true), bad code smell that hard to understand. use another other loop
        while active {
            guard active else { break }
            guard case .loggedIn(let session) = self.account.state.value else { return }
            
            /// TODO: HACK (Remove once sync can be done asynchronously)
            ///
            /// Fetching all conversations is done asynchronously, so there while loop will escape before it return with a result
            /// using a semaphore force a synchronous operation
            /// have to always manually give a signal to continue otherwise it will wait forever an
            let semaphore = DispatchSemaphore(value: 0)

            var hasFailedRequest = false
            
            /* Get the latest list of conversations, and see if there are any new ones, or if updates are available for existing ones. */
            conversationController.all(with: session.userId).subscribe(onNext: { [weak self] conversations in
                self?.process(conversations)
                
                semaphore.signal()
            }, onError: { _ in
                hasFailedRequest = true
                
                semaphore.signal()
            }).addDisposableTo(disposeBag)

            if hasFailedRequest {
                handleFatalError(error: HTTPSessionManager.Errors.requestFailed(error: ConversationClient.Errors.networking))

                break
            }

            // start synchronous operation
            _ = semaphore.wait(timeout: .distantFuture)
        }
    }

    // MARK:
    // MARK: Sync
    
    private func fetchConversation(for uuid: String) throws -> Conversation {
        /// TODO: HACK (Remove once sync can be done asynchronously)
        ///
        /// Fetching a conversation is done asynchronously, so there while loop will escape before it return with a result
        /// using a semaphore force a synchronous operation
        /// have to always manually give a signal to continue otherwise it will wait forever an
        let semaphore = DispatchSemaphore(value: 0)
        
        var conversation: Conversation?
        var error: Error = ConversationClient.Errors.networking

        conversationController.conversation(with: uuid).subscribe(onNext: { detailedConversation in
            conversation = detailedConversation
            
            semaphore.signal()
        }, onError: { newError in
            error = newError
            semaphore.signal()
        }).addDisposableTo(disposeBag)
        
        // start synchronous operation
        _ = semaphore.wait(timeout: .distantFuture)

        // Remove conversation if not found in backend
        if (error as? NetworkError)?.localizedTitle == NetworkError.Code.Conversation.notFound.rawValue,
            let conversationToDelete = objectCache.conversationCache.get(uuid: uuid) {
            
            if let myself = conversationToDelete.members.first(where: { $0.user.isMe }) {
                failedSyncedConversation.insert(ConversationPreviewModel(conversationToDelete.data.rest, for: myself.data.rest))
            }

            try databaseManager.conversation.delete(conversationToDelete.data)
        }

        guard let detailedConversation = conversation else { throw error }
        
        return detailedConversation
    }
    
    private func syncConversation(for uuid: String, isExisiting: Bool, invitedBy: Event.Body.MemberInvite?=nil) throws {
        let events: SignalInvocations = SignalInvocations()
        
        /* For this conversation, fetch the latest detail over REST. */
        let detail = try fetchConversation(for: uuid)
        
        /* Now get our local record from the database. */
        var cachedConversation = objectCache.conversationCache.get(uuid: uuid)
        
        /* If we've been invited to a new conversation, we may not have it in our records. */
        var isNewConversation: Bool
       
        if let conversation = cachedConversation, isExisiting == true {
            isNewConversation = conversation.data.dataIncomplete == true
        } else {
            isNewConversation = true
            cachedConversation = detail
        }
        
        guard let conversation = cachedConversation else { throw ConversationClient.Errors.userNotInCorrectState }

        try conversation.data.rest.members.forEach { _ = try syncUser(uuid: $0.userId) }
        try syncConversationMembers(conversation: conversation, detail: detail.data.rest, events: events)
        
        /* Sync events. */
        let newEventsReceived = try syncConversationEvents(conversation: conversation, events: events)

        /* Generate field change events for Conversation itself, and update with changes. */
        let (updatesMade, newEvents) = conversation.updateWithNewData(new: DBConversation(conversation: detail.data.rest))
        events.add(invocations: newEvents)
        
        /* Save any updates. */
        if updatesMade || conversation.data.dataIncomplete || conversation.data.requiresSync {
            conversation.data.dataIncomplete = false
            conversation.data.requiresSync = false

            try save(conversation.data.rest.members, for: conversation.uuid)
            try databaseManager.conversation.insert(conversation.data)
    
            /* Generate new conversation events. */
            if isNewConversation {
                conversationController.conversations.refetch()
                
                events.add {
                    // Notify of being invited by a certain user, triggered by socket event
                    if let invitedBy = invitedBy, let member = conversation.members.first(where: { $0.data.rest.name == invitedBy.invitedBy }) {
                        self.conversationController.conversations.value = .inserted([conversation], .invitedBy(member))

                        return
                    }

                    // Conversation with invited by in member that is yourself who got invited by another user
                    if let myMember = conversation.members.first(where: { $0.state == .invited && $0.user.isMe }),
                        let invitedByMember = conversation.members.first(where: { $0.data.rest.name == myMember.data.rest.invitedBy }) {
                        self.conversationController.conversations.value = .inserted([conversation], .invitedBy(invitedByMember))

                        return
                    }

                    /// Added new conversation to the collection
                    self.conversationController.conversations.value = .inserted([conversation], .new)
                }
            }
        }
        
        /* Do we need to refresh to lazy list of events? */
        if newEventsReceived {
            conversation.refreshAllEventsList()
        }
        
        /* Now we've got this conversation and everything under it synced, we can emit all the events. */
        events.emitAll()
    }
    
    private func syncConversationEvents(conversation: Conversation, events: SignalInvocations) throws -> Bool {
        state.tryWithValue = .active(.events)
        
        let lower: Int = {
            guard let index = conversation.data.mostRecentEventIndex else { return 0 }
            
            return Int(index) + 1
        }()
        
        var newConversationEvents: [Event]?
        
        ///////////////////////////////
        /// TODO: HACK (Remove once sync can be done asynchronously)
        ///
        /// fetch user is done asynchronously, so there while loop will escape before it return with a result
        /// using a semaphore force a synchronous operation
        /// have to always manually give a signal to continue otherwise it will wait forever
        let semaphore = DispatchSemaphore(value: 0)
        
        eventController.retrieve(
            for: conversation.uuid,
            with: Range<Int>(uncheckedBounds: (lower: lower, upper: 0)) // using zero make it max range 
            ).subscribe(onNext: { events in
                newConversationEvents = events
                
                semaphore.signal()
            }, onError: { _ in
                semaphore.signal()
            }
        ).addDisposableTo(disposeBag)
        
        // start synchronous operation
        _ = semaphore.wait(timeout: .distantFuture)
        
        try? newConversationEvents?.forEach { item in
            try processNewEvent(conversation: conversation, event: item, events: events, enableTypingEvents: false)
        }
        
        return newConversationEvents?.isEmpty == false
    }
    
    private func syncConversationMembers(conversation: Conversation, detail: ConversationModel, events: SignalInvocations) throws {
        state.tryWithValue = .active(.members)
        
        /* Member records are never deleted, just marked as having left the conversation. So
         this means the latest records received over REST will always be a superset of the
         records we have locally. Go through each member and see if the are either new, or
         have changed in some way. */
        var membershipUpdated = false
        for item in detail.members {
            /* Get the full membership details. */
            
            let restMember = item
            
            /* See if we can find this member in our existing records. */
            let existingMember = objectCache.memberCache.get(uuid: restMember.id)
            
            // TODO Sync full member information using: GET /v1/conversations/:id/members/:id or maybe GET /v1/conversations/:id/members
            
            if let existingMember = existingMember {
                /* Look for differences between restMember and existingMember and add events to our list. */
                let (updatesMade, newEvents) = existingMember.updateWithNewData(new: DBMember(conversationUuid: conversation.uuid, member: restMember), isMe: existingMember.user.isMe)
                events.add(invocations: newEvents)
                
                /* Save if updates were made. */
                if updatesMade {
                    try self.databaseManager.member.insert(existingMember.data)
                    
                    membershipUpdated = true
                }
            } else {
                /* Brand new member that we've not previously seen. */
                
                /* Sync the user. */
                // TODO Put something in here to stop us repeatedly syncing the same user when we sync a series of conversations all containing the same user (eg. us).
                let userSyncEvents = try syncUser(uuid: restMember.userId)
                events.add(invocations: userSyncEvents)
                
                /* Create the member record. */
                let newMember = Member(conversationUuid: detail.uuid, member: restMember)
                events.add { conversation.newMember.emit(newMember) }
                
                try self.databaseManager.member.insert(newMember.data)

                membershipUpdated = true
                
                guard let member = objectCache.memberCache.get(uuid: newMember.uuid) else { return }
                
                switch restMember.state {
                case .invited: events.add { conversation.memberInvited.emit(member) }
                default: break
                }
            }
        }

        conversation.refreshMemberCollection()
            
        if membershipUpdated {
            events.add { conversation.membersChanged.emit(()) }
        }
    }
    
    private func syncUser(uuid: String) throws -> SignalInvocations {
        state.tryWithValue = .active(.users)
        
        let events = SignalInvocations()

        // TODO Grab the mutex.
        
        /* For this conversation, fetch the latest detail over REST. */
        var detail: UserModel?
        
        ///////////////////////////////
        /// TODO: HACK (Remove once sync can be done asynchronously)
        ///
        /// fetch user is done asynchronously, so there while loop will escape before it return with a result
        /// using a semaphore force a synchronous operation
        /// have to always manually give a signal to continue otherwise it will wait forever
        let semaphore = DispatchSemaphore(value: 0)
        
        account.user(with: uuid).subscribe(onNext: { user in
            detail = user
            
            semaphore.signal()
        }, onError: { error in
            self.handleFatalError(error: HTTPSessionManager.Errors.requestFailed(error: error))
            
            semaphore.signal()
        }).addDisposableTo(disposeBag)
        
        // start synchronous operation
        _ = semaphore.wait(timeout: .distantFuture)

        guard let user = detail else {
            self.handleFatalError(error: HTTPSessionManager.Errors.requestFailed(error: nil))
            
            return events
        }
        
        /* See if we already have an existing record for this user. */
        
        if let existing = objectCache.userCache.get(uuid: uuid) {
            /* Update the existing record. */
            /* Look for differences between restMember and existingMember and adds events to our list. */
            let (updatesMade, newEvents) = existing.updateWithNewData(new: DBUser(data: user))
            events.add(invocations: newEvents)
            
            /* Save if updates were made. */
            if updatesMade {
                try self.databaseManager.user.update(existing.data)
            }
        } else {
            try self.databaseManager.user.insert(DBUser(data: user))
        }
        
        return events
    }
    
    /* Request the given user to be synced. This method can be called outside of the sync manager. */
    internal func requestSyncUser(uuid: String, callback: @escaping SyncManagerUserSyncCallback) {
        syncWorkerCondition.lock()
        usersRequiringSync.append((uuid, callback))
        syncWorkerCondition.signal()
        syncWorkerCondition.unlock()
    }

    // MARK:
    // MARK: Save
    
    // TODO: Move logic
    @discardableResult
    internal func save(_ conversation: ConversationModel) throws -> Conversation {
        let newConversation = Conversation(conversation,
                                              eventController: eventController,
                                              databaseManager: databaseManager,
                                              eventQueue: eventQueue,
                                              account: account,
                                              conversationController: conversationController,
                                              membershipController: membershipController
        )

        try save(newConversation.data.rest.members, for: conversation.uuid)
        try databaseManager.conversation.insert(newConversation.data)
        
        conversationController.conversations.refetch()
        
        return newConversation
    }
    
    // TODO: Move logic
    @discardableResult
    internal func save(_ membersModel: [MemberModel], for conversationId: String) throws -> [Member] {
        let members = membersModel
            .map { DBMember(conversationUuid: conversationId, member: $0) }
            .map { Member(data: $0) }
        
        try members.forEach { try self.databaseManager.member.insert($0.data) }
        
        return members
    }

    // MARK:
    // MARK: Process
    // TODO: Use builder process methods

    // WARNING: make sure to use breaks
    @discardableResult
    private func process(_ conversations: [ConversationPreviewModel]) -> [Conversation] {
        state.tryWithValue = .active(.conversations)

        var processedConversations = [Conversation]()
        var previewModels = [ConversationPreviewModel]()

        do {
            /* To make things less chaotic (and easier to debug), pause the task manager while we do the sync. */
            eventQueue.pause()

            for newConversation in conversations where !failedSyncedConversation.contains(newConversation) {
                /* See if we already have this conversation in the database. */
                if let existing = objectCache.conversationCache.get(uuid: newConversation.uuid) {
                    processedConversations.append(existing)
                    
                    // Existing, see if it needs updating
                    if newConversation.sequenceNumber > existing.data.rest.sequenceNumber {
                        existing.data.requiresSync = true

                        try databaseManager.conversation.insert(existing.data)
                    }
                } else {
                    previewModels.append(newConversation)
                }
            }

            /* Sync our user record. */
            guard case .loggedIn(let session) = account.state.value else { return [] }

            let newEvents = try syncUser(uuid: session.userId)
            newEvents.emitAll()

            // TODO Sync all Users before going the members in a conversation. Can't do this at the moment because the user record doesn't have a sequence number.

            /* Find all conversations that are in need of a sync. */
            try databaseManager.conversation.dirtyUuids.forEach { try syncConversation(for: $0, isExisiting: false) }
            try previewModels.forEach { try syncConversation(for: $0.uuid, isExisiting: false) }

            /* Main sync processor. Go in to a loop processing any events on the queue. */
            Log.info(.syncManager, "Main Sync Processor loop complete.")
            state.tryWithValue = .inactive

            eventQueue.enable()

            // TODO: remove while(true), bad code smell that hard to understand. use another other loop
            while true {
                /* Wait for a new event. */
                syncWorkerCondition.lock()
                while queue.isEmpty && usersRequiringSync.isEmpty {
                    syncWorkerCondition.wait()
                }

                /* Get the event from the queue and release the lock on the queue. */
                var newEvent: EventQueueItem? = nil

                if !queue.isEmpty {
                    newEvent = queue.removeFirst()
                }

                syncWorkerCondition.unlock()

                if let newEvent = newEvent {
                    // TODO: Research why we assume there only one conversation in list
                    let conversation = newEvent.0

                    /* Process the event. */
                    let events: SignalInvocations = SignalInvocations()
                    try processNewEvent(conversation: conversation, event: newEvent.1, events: events, enableTypingEvents: true)

                    if let conversation = conversation {
                        try save(conversation.data.rest.members, for: conversation.uuid)
                        try databaseManager.conversation.update(conversation.data)

                        conversation.refreshAllEventsList()
                    }

                    events.emitAll()

                    /* See if the conversation we've just processed, now requires a sync. */
                    if let conversation = conversation, conversation.data.requiresSync == true {
                        try syncConversation(for: conversation.uuid, isExisiting: true)
                    }
                }

                /* See if there are any user records requiring sync. */
                syncWorkerCondition.lock()
                var userSyncRequest: (String, SyncManagerUserSyncCallback)? = nil
                if !usersRequiringSync.isEmpty {
                    userSyncRequest = usersRequiringSync.removeFirst()
                }
                syncWorkerCondition.unlock()

                if let userSyncRequest = userSyncRequest {
                    /* Get the UUID and callback from the request. */
                    let uuid = userSyncRequest.0
                    let callback = userSyncRequest.1

                    let userSyncEvents = try syncUser(uuid: uuid)
                    userSyncEvents.emitAll()

                    /* Fetch the record which should now exist. */
                    let record = objectCache.userCache.get(uuid: uuid)
                    callback(record)
                }
            }
        } catch HTTPSessionManager.Errors.malformedJSON {
            /* Server sent us invalid JSON, we treat this as fatal because otherwise we will probably get out knickers in a twist. */
            handleFatalError(error: HTTPSessionManager.Errors.malformedJSON)
        } catch HTTPSessionManager.Errors.requestFailed(let error) {
            /* The request failed. We currently treat this as fatal. */
            // TODO Build a retry mechanism into the low level routine syncResponseJSON(), but only use it on methods that are safe to retry.
            // TODO If the retry still fails, we shouldn't give up, we should take it from the top and start a sync again.
            handleFatalError(error: HTTPSessionManager.Errors.requestFailed(error: error))
        } catch let error where (error as? NetworkErrorProtocol)?.localizedTitle == NetworkError.Code.Conversation.notFound.rawValue {

        } catch let error {
            handleFatalError(error: error)
        }

        return processedConversations
    }

    /*
     Sync events on the given conversation.
 
     Note: It is up to the caller of this function to do the Save of the conversation to the database so that mostRecentEventIndex is updated.
     */
    private func processNewEvent(conversation: Conversation?, event: Event, events: SignalInvocations, enableTypingEvents: Bool) throws {
        /* There are two scenarios, one where we found the conversation, one where we didn't. Most events require
           the conversation to be found and it's an error if it's not found. The exception is for a new conversation
           where obviously it wouldn't have been found. */
        if let conversation = conversation {
            switch event.type {
                case .memberInvited, .memberJoined, .memberLeft:
                    conversation.data.requiresSync = true
                    
                    try processMemberEvent(conversation: conversation, event: event, events: events)
                case .text, .image:
                    try processEvent(conversation: conversation, event: event, events: events)
                case .textSeen, .textDelivered, .imageDelivered, .imageSeen:
                    try processReceiptEvent(conversation: conversation, event: event, events: events)
                case .textTypingOn, .textTypingOff:
                    try processTyping(conversation: conversation, event: event, events: events)
                case .eventDelete:
                    eventQueue.removeDeletedEvent(event)
            }
            
            conversation.data.mostRecentEventIndex = event.id
        } else {
            /* The conversation was not found, see if this is us being invited to a new conversation event. */
            if event.type == .memberInvited, let invitedBy: Event.Body.MemberInvite = event.model() {
                try syncConversation(for: event.cid, isExisiting: false, invitedBy: invitedBy)
            /* See if it's us joining our own newly created conversation. */
            } else if event.type == .memberJoined && event.id == 1 {
                try syncConversation(for: event.cid, isExisiting: false)
            }
        }
    }
    
    // TODO: decouple... should this one method do: create event model, save to database, do sync, process seen, cache, trigger delivered, notify observer
    private func processEvent(conversation: Conversation, event: Event, events: SignalInvocations) throws {
        /* See if this new message is a sent message for one of our drafts. If so, replace the draft. */
        let draftEvent: DBEvent? = databaseManager.event.getDraft(event.id, in: conversation.uuid)
        
        if let draftEvent = draftEvent {
            try databaseManager.event.delete(draftEvent)
        }
        
        /* Process seen. */
        var seen = false
        
        if let eventsSeen = event.state?.seenBy {
            let ourIds = conversation.ourMemberRecords.map { $0.uuid }
            
            if !ourIds.filter(eventsSeen.keys.contains).isEmpty {
                seen = true
            }
        }
        
        /* Create a new record. */
        guard let newMessage = EventBase.factory(data: DBEvent(conversationUuid: conversation.uuid, event: event, seen: seen)) else {
            return
        }

        Log.info(.syncManager, "New message: " + newMessage.description)
        
        /* Calculate the distribution list for this event. */
        newMessage.data.distribution = conversation.members.uuids
        
        /// Append image data so we don't have to fetch it over the network
        newMessage.data.payload = draftEvent?.payload
        
        conversation.data.lastUpdated = newMessage.createDate
        
        /* Save it in the database. */
        try databaseManager.event.insert(newMessage.data)
        try databaseManager.conversation.update(conversation.data)
        
        /* Reload it from the cache. */
        let fromCache = objectCache.eventCache.get(uuid: newMessage.uuid)
        
        /* Get the delivered information from the event body to see if we need to send a delivery indication. */
        var needToNotifyDelivered = true
        
        /* We can't send the notification if we're not joined, or if the message is from us. */
        // TODO conversation.state is not valid!
        if fromCache?.from.isMe == true {
            needToNotifyDelivered = false
        }
        
        /* Process delivered. */
        if let eventsDelivered = event.state?.deliveredTo {
            let ourIds = conversation.ourMemberRecords.map { $0.uuid }
            
            if !ourIds.filter(eventsDelivered.keys.contains).isEmpty {
                needToNotifyDelivered = false
            }
        }

        guard let event = fromCache as? TextEvent else { return }

        if needToNotifyDelivered {
            try eventQueue.add(.indicateDelivered, with: event)
        }
        
        events.add {
            self.conversationController.conversations.value = .updated([conversation])

            conversation.newEventReceived.emit(event)
        }
    }
    
    private func processTyping(conversation: Conversation, event: Event, events: SignalInvocations) throws {
        //TODO: do we need to save this event to the database? ie see processNewMessage
        
        /* Get the member. */
        guard let from = event.from, let member = objectCache.memberCache.get(uuid: from) else {
            Log.error(.syncManager, "Typing event from unknown member.")
            return
        }
        
        /* Get type */
        let isTyping = event.type == .textTypingOn

        events.add { member.typing.value = isTyping }
    }

    private func processReceiptEvent(conversation: Conversation, event: Event, events: SignalInvocations) throws {
        state.tryWithValue = .active(.receipts)
        
        /* Get the member. */
        guard let from = event.from,
            let member = objectCache.memberCache.get(uuid: from),
            let body = event.body else {
            Log.error(.syncManager, "Receipt event from unknown member or from.")
            
            return
        }
        
        guard let eventId = { () -> Int32? in
            if let eventId: Int32 = "event_id" <~~ body {
                return eventId
            } else if let eventId: String = "event_id" <~~ body {
                // FIXME: https://nexmoinc.atlassian.net/browse/CS-345
                return Int32(eventId)
            }
        
            return nil
        }() else {
            return
        }
        
        /* Get the details of the related text event. */
        let textEventUuid = EventBase.uuid(from: eventId, in: conversation.uuid)
        
        guard let textEvent = objectCache.eventCache.get(uuid: textEventUuid) as? TextEvent else { return }
        
        /* See if we have an existing receipt record for this member+event. */
        let uuid = ReceiptRecord.memberAndEventToUUID(memberId: member.uuid, textEventId: eventId)
        
        if let existing = objectCache.receiptCache.get(uuid: uuid) {
            if event.type == .textSeen || event.type == .imageSeen {
                existing.data.seenDate = event.timestamp
                existing.date = event.timestamp
            } else if event.type == .textDelivered || event.type == .imageDelivered {
                existing.date = event.timestamp
            }

            try databaseManager.receipt.insert(existing.data)
            
            events.add { textEvent.receiptRecordChanged.emit((textEvent, existing)) }
        } else {
            /* Create a new record. */
            let record = DBReceipt(conversationId: conversation.uuid, memberId: member.uuid, eventId: eventId)
            
            if event.type == .textDelivered || event.type == .imageDelivered {
                record.deliveredDate = event.timestamp
            } else if event.type == .textSeen || event.type == .imageSeen {
                Log.error(.syncManager, "New " + event.type.rawValue + " receipt for " + member.description + " on event: " + String(eventId) + " - got a seen receipt before a delivered receipt?")
                record.seenDate = event.timestamp
            }
            
            let newReceipt = ReceiptRecord(data: record)
            
            try databaseManager.receipt.insert(newReceipt.data)
            
            /* Generate an event on the related event. */
            textEvent.refreshReceipts()
            
            // TODO Optimisation: It is a bit wasteful to get the event from the cache and emit the event, if nobody else had a copy of the
            // event. Be better to make a helper (in the cache mamanger) which atomically looks to see if it's already in the cache, and
            // only bothers with emitting the event if the object was already in the cache. Can do for all cached object types, not just
            // receipt records.
            events.add { textEvent.newReceiptRecord.emit((textEvent, newReceipt)) }
        }
    }
    
    private func processMemberEvent(conversation: Conversation, event: Event, events: SignalInvocations) throws {
        let membershipEvent: MembershipEvent? = {
            switch event.type {
            case .memberInvited:
                return MemberInvitedEvent(conversationUuid: conversation.uuid, event: event, seen: false)
            case .memberJoined:
                return MemberJoinedEvent(conversationUuid: conversation.uuid, event: event, seen: false)
            case .memberLeft:
                return MemberLeftEvent(conversationUuid: conversation.uuid, event: event, seen: false)
            default:
                // It should never go to this case
                return nil
            }
        }()
        
        guard let membership = membershipEvent else { return }
        
        try databaseManager.event.insert(membership.data)
        
        switch event.type {
        case .memberInvited:
            guard let invitedMember = (membershipEvent as? MemberInvitedEvent)?.invitedMember else { return }
            
            events.add { conversation.memberInvited.emit(invitedMember) }
        case .memberJoined:
            events.add { conversation.memberJoined.emit(membership.fromMember) }
        case .memberLeft:
            events.add { conversation.memberLeft.emit(membership.fromMember) }
        default:
            break
        }
    }
    
    // MARK:
    // MARK: Error

    private func handleFatalError(error: Error?) {
        active = false
        state.tryWithValue = .failed
        
        close()
    }
    
    internal func reconnect() {
        active = true // this will allow the run loop to continue
    }
    
    // MARK:
    // MARK: Event
    
    internal func receivedEvent(_ event: Event) -> Observable<Void> {
        return Observable<Void>.create { observer in
            let conversation = self.objectCache.conversationCache.get(uuid: event.cid)
            
            self.syncWorkerCondition.lock()
            self.queue.append(conversation, event)
            self.syncWorkerCondition.signal()
            self.syncWorkerCondition.unlock()
            
            observer.onNext(())
            
            return Disposables.create()
        }
    }
}
