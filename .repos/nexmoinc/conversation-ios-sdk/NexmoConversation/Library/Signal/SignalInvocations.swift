//
//  SignalInvocations.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 21/04/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/*
 Helper to lazily store a series of signal emissions and emit them all at a later date.
 */
internal class SignalInvocations {
    
    // MARK:
    // MARK: Type
    
    internal typealias Invocation = () -> Void
    
    // MARK:
    // MARK: Properties
    
    private var invocations: [Invocation] = []
    
    // MARK:
    // MARK: Emit
    
    internal func add(invocation: @escaping () -> Void) {
        invocations.append(invocation)
    }
    
    internal func add(invocations: SignalInvocations) {
        self.invocations.append(contentsOf: invocations.invocations)
    }
    
    internal func emitAll() {
        for item in invocations {
            item()
        }
        
        invocations.removeAll()
    }
    
    // MARK:
    // MARK: Compare
    
    /*
     Helper to compare the current value of a field with a new value. If there is a difference, the
     update is made and an optional signal can be added to the list of signals.
     */
    internal static func compareField<T: Equatable>(current: inout T, new: T, updatesMade: inout Bool, signals: SignalInvocations, signal: @escaping (T, T) -> Void) {
        if current != new {
            let currentValue: T = current
            signals.add { signal(currentValue, new) }
            current = new
            updatesMade = true
        }
    }
}
