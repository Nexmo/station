//
//  Platform.swift
//  ConversationDemo
//
//  Created by shams ahmed on 21/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation

/// Validate platform
internal struct Platform {
    
    // MARK:
    // MARK: Platform
    
    /// Test for simulator target
    internal static let isSimulator: Bool = {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            return true
        #else
            return false
        #endif
    }()
}
