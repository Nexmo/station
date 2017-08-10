//
//  SubscriptionService.swift
//  NexmoConversation
//
//  Created by shams ahmed on 22/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import RxSwift

/// Service for all custom listeners 
internal struct SubscriptionService {
    
    /// New events from capi socket
    internal let events = Variable<Event?>(nil)
    
    private let webSocketManager: WebSocketManager
    
    private let disposeBag = DisposeBag()
    
    /// Processing queue for new eventss
    private let serialDispatchQueue: SerialDispatchQueueScheduler
    
    // MARK:
    // MARK: Initializers
    
    internal init(webSocketManager: WebSocketManager) {
        self.webSocketManager = webSocketManager
        serialDispatchQueue = SerialDispatchQueueScheduler(
            queue: webSocketManager.queue, 
            internalSerialQueueName: webSocketManager.queue.label
        )
        
        setup()
    }
    
    // MARK:
    // MARK: Private - Setup
    
    private func setup() {
        bindMemberListener()
        bindTextListener()
        bindEventListener()
    }
    
    // MARK:
    // MARK: Private - binding
    
    private func bindMemberListener() {
        webSocketManager.on(Event.EventType.memberInvited.rawValue) { self.handleEvent(.memberInvited, with: $0) }
        webSocketManager.on(Event.EventType.memberJoined.rawValue) { self.handleEvent(.memberJoined, with: $0) }
        webSocketManager.on(Event.EventType.memberLeft.rawValue) { self.handleEvent(.memberLeft, with: $0) }
    }
    
    private func bindTextListener() {
        webSocketManager.on(Event.EventType.textTypingOn.rawValue) { self.handleEvent(.textTypingOn, with: $0) }
        webSocketManager.on(Event.EventType.textTypingOff.rawValue) { self.handleEvent(.textTypingOff, with: $0) }
        webSocketManager.on(Event.EventType.textSeen.rawValue) { self.handleEvent(.textSeen, with: $0) }
        webSocketManager.on(Event.EventType.textDelivered.rawValue) { self.handleEvent(.textDelivered, with: $0) }
        webSocketManager.on(Event.EventType.text.rawValue) { self.handleEvent(.text, with: $0) }
    }
    
    private func bindEventListener() {
        webSocketManager.on(Event.EventType.eventDelete.rawValue) { self.handleEvent(.eventDelete, with: $0) }
        webSocketManager.on(Event.EventType.image.rawValue) { self.handleEvent(.image, with: $0) }
        webSocketManager.on(Event.EventType.imageDelivered.rawValue) { self.handleEvent(.imageDelivered, with: $0) }
    }

    // MARK:
    // MARK: Private - Handler
    
    private func handleEvent(_ event: Event.EventType, with data: [Any]) {
        Observable<Event>.create { observer in
            guard let json = data.first as? [String : Any], let event = Event(type: event, json: json) else {
                return Disposables.create()
            }
            
            observer.onNextWithCompleted(event)
            
            return Disposables.create()
            }
            .subscribeOn(serialDispatchQueue)
            .bind(to: events)
            .addDisposableTo(disposeBag)
    }
}
