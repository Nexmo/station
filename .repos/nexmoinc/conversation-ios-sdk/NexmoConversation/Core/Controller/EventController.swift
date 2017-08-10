//
//  EventController.swift
//  NexmoConversation
//
//  Created by shams ahmed on 29/12/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import RxSwift

/// Manage and send event for a conversation
@objc
internal class EventController: NSObject {
    
    /// Network controller
    private let networkController: NetworkController
    
    /// Rx
    internal let disposeBag = DisposeBag()
    
    // MARK:
    // MARK: Initializers
    
    internal init(network: NetworkController) {
        networkController = network
    }
    
    // MARK:
    // MARK: Send
    
    /// Send a event
    ///
    /// - Parameters:
    /// - model: event model
    /// - Returns: observable with event result
    internal func send(_ event: SendEvent) -> Observable<EventResponse> {
        return Observable<EventResponse>.create { observer -> Disposable in
            self.networkController.eventService.send(event: event, success: { response in
                observer.onNextWithCompleted(response)
            }, failure: { error in
                observer.onError(error)
            })
            
            return Disposables.create()
        }
        .observeOnBackground()
    }
    
    /// Send a image event
    ///
    /// - Parameters:
    /// - model: image model
    /// - Returns: observable with event result
    internal func send(_ image: IPSService.UploadImageParameter, conversationId: String, fromId: String) -> Observable<EventResponse> {
        return Observable<EventResponse>.create { observer -> Disposable in
            self.networkController.eventService.upload(image: image, conversationId: conversationId, fromId: fromId, success: { response in
                observer.onNextWithCompleted(response)
            }, failure: { error in
                observer.onError(error)
            })
            
            return Disposables.create()
        }
        .observeOnBackground()
    }
    
    // MARK:
    // MARK: Retrieve
    
    /// Retrieve events with a range
    /// Default to start: 0 end: 20
    ///
    /// - Parameters:
    /// - for: conversation uuid
    /// - with: range start/end
    /// - Returns: observable with list of events
    internal func retrieve(for uuid: String, with range: Range<Int> = Range<Int>(uncheckedBounds: (lower: 0, upper: 20))) -> Observable<[Event]> {
        return Observable<[Event]>.create { observer -> Disposable in
            self.networkController.eventService.retrieve(for: uuid, with: range, success: { response in
                observer.onNextWithCompleted(response)
            }, failure: { error in
                observer.onError(error)
            })
            
            return Disposables.create()
        }
        .observeOnBackground()
    }
    
    // MARK:
    // MARK: Delete
    
    /// Delete event
    ///
    /// - Parameters:
    ///   - eventId: eventId
    ///   - memberId: memberId
    ///   - uuid: uuid
    /// - Returns: Observable
    internal func delete(_ eventId: Int, for memberId: String, in uuid: String) -> Observable<Event> {
        return Observable<Event>.create { observer -> Disposable in
            self.networkController.eventService.delete(eventId, for: memberId, in: uuid, success: { event in
                observer.onNextWithCompleted(event)
            }, failure: { error in
                observer.onError(error)
            })
            
            return Disposables.create()
        }
        .observeOnBackground()
    }
}
