//
//  ObservableType+Threading.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 26/10/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - Helper to move workload to other threads
public extension ObservableType {

    // MARK:
    // MARK: Observe
    
    /// Async Main thread of where the result is sent after this point, only to be used for UI.
    ///
    /// - Returns: Observable
    public func observeOnMainThread() -> RxSwift.Observable<Self.E> {
        return observeOn(MainScheduler.asyncInstance)
    }

    /// Background thread of where the result is sent after this point
    ///
    /// - Returns: Observable
    public func observeOnBackground() -> RxSwift.Observable<Self.E> {
        return observeOn(ConcurrentDispatchQueueScheduler.background)
    }
    
    // MARK:
    // MARK: Subscribe
    
    /// Async Main thread - Where all the actual work is processed
    ///
    /// - Returns: Observable
    internal func subscribeOnMainThread() -> RxSwift.Observable<Self.E> {
        return subscribeOn(MainScheduler.asyncInstance)
    }
    
    /// Background thread - Where all the actual work is processed
    ///
    /// - Returns: Observable
    internal func subscribeOnBackground() -> RxSwift.Observable<Self.E> {
        return subscribeOn(ConcurrentDispatchQueueScheduler.background)
    }
}
