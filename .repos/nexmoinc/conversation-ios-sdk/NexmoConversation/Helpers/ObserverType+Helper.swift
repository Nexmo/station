//
//  ObserverType+Helper.swift
//  NexmoConversation
//
//  Created by shams ahmed on 03/07/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import RxSwift

internal extension ObserverType {
    
    // MARK:
    // MARK: Observer
    
    /// Convenience method equivalent to `on(.completed)` and on(.next)
    internal func onNextWithCompleted(_ element: Self.E) {
        on(.next(element))
        on(.completed)
    }
}
