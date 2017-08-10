//
//  SignalHandlerWrapper.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 21/04/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/*
 This wrapper class is used to weakly remember details of a Swift handler.
 */
internal protocol SignalHandlerWrapper: class {
    func invoke(_ data: Any)
    func isTargetGarbageCollected() -> Bool
}

internal class SignalHandlerContainer<T: AnyObject, U>: SignalHandlerWrapper {
    
    // MARK:
    // MARK: Properties
    
    private var onUIThread: Bool
    private weak var target: T?
    private let handler: (T) -> (U) -> Void
    
    // MARK:
    // MARK: Initializers
    
    internal init(onUIThread: Bool, target: T?, handler: @escaping (T) -> (U) -> Void) {
        self.onUIThread = onUIThread
        self.target = target
        self.handler = handler
    }
    
    // MARK:
    // MARK: Invoke

    internal func invoke(_ data: Any) {
        if let t = target {
            if onUIThread {
                DispatchQueue.main.async {
                    self.handler(t)(data as! U) // TODO - Test this is actually exercised.
                }
            } else {
                handler(t)(data as! U)
            }
        }
    }
    
    // MARK:
    // MARK: Garbage
    
    internal func isTargetGarbageCollected() -> Bool {
        return (target == nil)
    }
}
