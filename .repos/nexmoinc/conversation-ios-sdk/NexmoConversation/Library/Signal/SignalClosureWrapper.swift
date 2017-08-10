//
//  SignalClosureWrapper.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 21/04/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/*
 This wrapper class is used to weakly remember details of a closure handler.
 */
internal protocol SignalClosureWrapper: class {
    
    // MARK:
    // MARK: Invoke
    
    func invoke(_ data: Any)
    func isTargetGarbageCollected() -> Bool
}

internal class SignalClosureContainer<U>: SignalClosureWrapper {
    
    private var onUIThread: Bool
    private var closure: (U) -> Void
    
    // MARK:
    // MARK: Initializers
    
    internal init(onUIThread: Bool, closure: @escaping (U) -> Void) {
        self.onUIThread = onUIThread
        self.closure = closure
    }
    
    // MARK:
    // MARK: Invoke
    
    internal func invoke(_ data: Any) {
        if onUIThread {
            DispatchQueue.main.async {
                self.closure(data as! U) // TODO - Test this is actually exercised.
            }
        } else {
            closure(data as! U)
        }
    }
    
    internal func isTargetGarbageCollected() -> Bool {
        let weakClosure: ((U) -> Void)? = closure
        
        return weakClosure == nil
    }
}
