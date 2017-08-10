//
//  Swizzle.swift
//  NexmoConversation
//
//  Created by shams ahmed on 12/04/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/// Helper to replace method implementations
internal struct Swizzle {
    
    /// Class and method
    internal typealias Method = (selector: Selector, forClass: AnyClass?)
    
    // MARK:
    // MARK: Swizzling
    
    /// Replace existing method
    ///
    /// - Parameters:
    ///   - orignal: existing method
    ///   - new: new method
    internal static func method(_ orignal: Method, with new: Method) {
        let originalMethod = class_getInstanceMethod(orignal.forClass, orignal.selector)
        let swizzledMethod = class_getInstanceMethod(new.forClass, new.selector)
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}
