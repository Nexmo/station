//
//  Dictionary+Helper.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 02/11/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation

// MARK:
// MARK: Operator

/// Merge two dictionary
///
/// - Parameters:
///   - lhs: insert to left hand side
///   - rhs: values to add
internal func += <KeyType, ValueType> (lhs: inout [KeyType: ValueType], rhs: [KeyType: ValueType]) {
    rhs.forEach { lhs.updateValue($0.value, forKey: $0.key) }
}
