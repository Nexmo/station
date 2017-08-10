//
//  ModifyDBEventOperation.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 11/05/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import RxSwift

/// Operation to remove a event from the database
internal struct ModifyDBEventOperation: Operation {
    
    internal typealias T = Void
    
    internal enum Errors: Error {
        case eventNotFoundInCache
    }
    
    private let event: Event?
    private let task: DBTask?
    private let cache: CacheManager
    private let database: DatabaseManager
    
    private var uuid: String? {
        if let uuid = task?.related {
            return uuid
        } else if let cid = event?.cid, let id = event?.id {
            return EventBase.uuid(from: id, in: cid)
        }
        
        return nil
    }
    
    // MARK:
    // MARK: Initializers

    internal init(_ event: Event?, with task: DBTask?=nil, cache: CacheManager, database: DatabaseManager) {
        self.event = event
        self.task = task
        self.cache = cache
        self.database = database
    }
    
    // MARK:
    // MARK: Operation
    
    internal func perform() throws -> Maybe<T> {
        return Maybe<T>.create(subscribe: { observer in
            do {
                try self.modifyEvent()

                observer(.success(()))
                observer(.completed)
            } catch let error {
                observer(.error(error))
            }
            
            return Disposables.create()
        })
    }
    
    // MARK:
    // MARK: Private - Delete
    
    private func modifyEvent() throws {
        guard let delete: Event.Body.Delete = event?.model() else { throw Errors.eventNotFoundInCache }
        
        // delete task
        if let task = task {
            try database.task.delete(task)
        }
        
        guard let eventId = Int32(delete.event), let conversationId = event?.cid else {
            throw Errors.eventNotFoundInCache
        }

        // find old event
        guard let oldDBEvent = cache.eventCache.get(uuid: EventBase.uuid(from: eventId, in: conversationId)) else {
            throw Errors.eventNotFoundInCache
        }

        // remove old event payload
        let oldEvent = oldDBEvent.data.rest
        oldEvent.body = [:]
        oldEvent.timestamp = Date()

        // save events
        try database.event.update(DBEvent(conversationUuid: conversationId, event: oldEvent, seen: true))

        if let event = event {
            try database.event.insert(DBEvent(conversationUuid: conversationId, event: event, seen: true))
        }

        let indexPath: [IndexPath] = {
            guard let index = oldDBEvent.conversation.allEvents.index(of: oldDBEvent) else { return [] }

            return [IndexPath(index: index)]
        }()

        // remove the old event from cache
        cache.eventCache.clear(uuid: oldDBEvent.uuid)

        // update observer
        oldDBEvent.conversation.events.emit(([], Conversation.Change.deletes(indexPath)))
    }
}
