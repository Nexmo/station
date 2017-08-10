//
//  SendIndicationOperation.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 14/05/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import RxSwift

/// Operation to send a indctator
internal struct SendIndicationOperation: Operation {
    
    internal typealias T = Void
    
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
        return try send(task)
    }
    
    // MARK:
    // MARK: Private - Send indicate

    private func send(_ task: DBTask) throws -> Maybe<T> {
        task.beingProcessed = true
        try database.task.insert(task)
        
        guard let eventUuid = task.related,
            let event = cache.eventCache.get(uuid: eventUuid) as? TextEvent,
            let memberId = event.conversation.ourMemberRecord?.uuid else {
            throw Errors.eventNotFound
        }
        
        var type: Event.EventType = .textDelivered
        
        if task.type == .indicateDelivered {
            type = event is ImageEvent ? .imageDelivered : .textDelivered
        } else if task.type == .indicateSeen {
            type = event is ImageEvent ? .imageSeen : .textSeen
        }
        
        let sendEvent = SendEvent(conversationId: event.conversation.uuid, from: memberId, type: type, eventId: Int(event.data.id))

        return eventController.send(sendEvent).catchError { error -> Observable<EventResponse> in
            guard let networkError = error as? NetworkError else { return Observable<EventResponse>.error(error) }

            switch networkError.localizedTitle {
            case NetworkError.Code.Text.notJoined.rawValue,
                 NetworkError.Code.IPS.notJoined.rawValue,
                 NetworkError.Code.RTC.notJoined.rawValue,
                 NetworkError.Code.Event.notJoined.rawValue:
                _ = try? self.database.task.delete(task)

                return Observable<EventResponse>.empty()
            default:
                return Observable<EventResponse>.error(error)
            }
        }.map { _ -> T in
            _ = try? self.database.task.delete(task)
            
            return ()
        }.asMaybe()
    }
}
