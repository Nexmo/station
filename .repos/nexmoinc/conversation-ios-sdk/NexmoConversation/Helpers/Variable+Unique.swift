//
//  Variable+Unique.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 19/05/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - Update for unique values
internal extension Variable where Element: Equatable {

    // MARK:
    // MARK: Value
    
    /// Only update value if its not unique
    internal var tryWithValue: E {
        get {
            return value
        }
        set {
            guard newValue != value else { return }
            
            value = newValue
        }
    }
}
