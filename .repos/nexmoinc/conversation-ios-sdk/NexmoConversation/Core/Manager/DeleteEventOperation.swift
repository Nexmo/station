//
//  DeleteEventOperation.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 11/05/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import RxSwift

/// Operation to delete a event 
internal struct DeleteEventOperation: Operation {
    
    internal typealias T = Event
    
    internal enum Errors: Error {
        case eventNotFound
        case failedToProcessEvent
    }
    
    private let task: DBTask
    private let cache: CacheManager
    private let database: DatabaseManager
    private let eventController: EventController
    
    // MARK:
    // MARK: Initializers

    internal init(_ task: DBTask,
                  cache: CacheManager,
                  database: DatabaseManager,
                  eventController: EventController) {
        self.task = task
        self.cache = cache
        self.database = database
        self.eventController = eventController
    }
    
    // MARK:
    // MARK: Operation
    
    internal func perform() throws -> Maybe<T> {
        return try delete(task)
    }
    
    // MARK:
    // MARK: Private - Delete
    
    private func delete(_ task: DBTask) throws -> Maybe<T> {
        task.beingProcessed = true
        try database.task.insert(task)
        
        guard let uuid = task.related, let event = cache.eventCache.get(uuid: uuid) else { throw Errors.eventNotFound }
        guard let member = event.conversation.ourMemberRecord else { throw Errors.failedToProcessEvent }
        
        Log.info(.taskProcessor, "Processing event to delete, id = \(task.uuid ?? 0), event = \(uuid)")
        
        return eventController
            .delete(Int(event.id), for: member.uuid, in: event.conversation.uuid)
            .asMaybe()
    }
}
