//
//  SignalReference.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 21/04/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/*
 This class provides a unique reference to a handler that has been added to an signal.
 It is used to later remove the handler.
 */
@objc(NXMSignalReference)
public class SignalReference: NSObject {
    
    // MARK:
    // MARK: Properties
    
    private static var uniqueReference: Int = 0
    private var reference: Int = 0
    private var parentSignal: SignalBase?
    
    // MARK:
    // MARK: NSObject
    
    @objc public override var hash: Int { return self.reference }
    
    // MARK:
    // MARK: Initializers
    
    internal init(parent: SignalBase) {
        super.init()
        
        parentSignal = parent
        
        SignalReference.uniqueReference += 1
        reference = SignalReference.uniqueReference
    }
    
    // MARK:
    // MARK: Override - Equal
    
    @objc public override func isEqual(_ object: Any?) -> Bool {
        if object is SignalReference {
            let object = object as! SignalReference
            
            return (object.reference == self.reference)
        }
        
        return false
    }
    
    // MARK:
    // MARK: Disposable
    
    /// Remove this handler from its signal.
    @objc
    public func dispose() {
        parentSignal?.removeHandler(self)
    }
}
