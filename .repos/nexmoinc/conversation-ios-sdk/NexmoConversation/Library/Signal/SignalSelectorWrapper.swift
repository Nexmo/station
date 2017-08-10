//
//  SignalSelectorWrapper.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 21/04/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/*
 This wrapper class is used to weakly remember details of a selector handler.
 */
internal class SignalSelectorWrapper {
    
    private var onUIThread: Bool
    private weak var target: AnyObject?
    private var selector: Selector
    
    // MARK:
    // MARK: Initializers
    
    internal init(onUIThread: Bool, target: AnyObject, selector: Selector) {
        self.onUIThread = onUIThread
        self.target = target
        self.selector = selector
    }
    
    // MARK:
    // MARK: Invoke
    
    internal func invoke(parameters: [AnyObject?]) {
        if onUIThread {
            DispatchQueue.main.async {
                if parameters.isEmpty {
                    _ = self.target?.perform(self.selector)
                } else if parameters.count == 1 {
                    _ = self.target?.perform(self.selector, with: parameters[0])
                } else if parameters.count == 2 {
                    _ = self.target?.perform(self.selector, with: parameters[0], with: parameters[1])
                }
            }
        } else {
            if parameters.isEmpty {
                _ = target?.perform(selector)
            } else if parameters.count == 1 {
                _ = target?.perform(selector, with: parameters[0])
            } else if parameters.count == 2 {
                _ = target?.perform(selector, with: parameters[0], with: parameters[1])
            }
        }
    }
    
    internal func isTargetGarbageCollected() -> Bool {
        return (target == nil)
    }
}
