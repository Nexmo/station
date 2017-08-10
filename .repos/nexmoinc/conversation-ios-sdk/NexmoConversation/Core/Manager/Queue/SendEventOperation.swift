//
//  SendEventOperation.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 13/05/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import RxSwift

/// Operation: Sending events
internal struct SendEventOperation: Operation {
    
    internal typealias T = EventResponse
    
    internal enum Errors: Error {
        case failedToProcessEvent
    }
    
    private let event: EventBase
    private let eventController: EventController
    
    // MARK:
    // MARK: Initializers

    internal init(_ event: EventBase, eventController: EventController) {
        self.event = event
        self.eventController = eventController
    }
    
    // MARK:
    // MARK: Operation
    
    internal func perform() throws -> Maybe<T> {
        switch event {
        case let image as ImageEvent: return try send(image)
        case let text as TextEvent: return try send(text)
        default: throw Errors.failedToProcessEvent
        }
    }
    
    // MARK:
    // MARK: Private - Request

    private func send(_ event: TextEvent) throws -> Maybe<T> {
        guard let text = event.text else { throw Errors.failedToProcessEvent }
        
        let model = SendEvent(conversationId: event.conversation.uuid, from: event.fromMember.uuid, text: text)
        
        return eventController.send(model).asMaybe()
    }
    
    private func send(_ event: ImageEvent) throws -> Maybe<T> {
        guard let data = event.image else { throw Errors.failedToProcessEvent }
        
        let parameters: IPSService.UploadImageParameter = (
            image: data,
            size: (originalRatio: nil, mediumRatio: nil, thumbnailRatio: nil)
        )
        
        return eventController.send(
            parameters,
            conversationId: event.conversation.uuid,
            fromId: event.fromMember.uuid
        ).asMaybe()
    }
}
