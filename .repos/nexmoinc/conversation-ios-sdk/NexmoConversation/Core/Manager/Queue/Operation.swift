//
//  Operation.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 11/05/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import RxSwift

/// Protocol for performing varies ask on queue
internal protocol Operation {
    
    associatedtype T
    
    /// Perform a task and return a result
    ///
    /// - Throws: throws whenever operation failed to perform its work
    func perform() throws -> Maybe<T>
}
