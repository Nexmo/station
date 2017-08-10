//
//  Environment.swift
//  NexmoConversation
//
//  Created by shams ahmed on 27/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation

/// Validate build environment
internal struct Environment {
    
    /// Shared singleton
    internal static var `default`: Environment = Environment(forceTest: false)
    
    /// Build type in workspace
    ///
    /// - QA:  QA
    /// - DEV: DEV
    private enum BuildType: String {
        case QA, DEV
    }
    
    /// Only to be used for unit testing for forcing a test pass, @Warning DEBUG mode only
    private var forceTest: Bool = false
    
    /// Only to be used for unit testing, disable in testing check, @Warning DEBUG mode only
    private var disableTestCheck: Bool = false
    
    // MARK:
    // MARK: Static
    
    /// Test to check if build is in debug environment, @Warning DEBUG mode only
    internal static var inDebug: Bool { return Environment.default.inDebug }
    
    /// Test to check if build is in DEV environment, @Warning DEBUG mode only
    internal static var inDEV: Bool { return Environment.default.inDEV }
    
    /// Test if the current build includes Test frameworks, @Warning DEBUG mode only
    internal static var inTesting: Bool { return Environment.default.inTesting }
    
    /// Test if the current build in in DEBUG mode, Testing mode wants a controlled error
    internal static var inFatalErrorTesting: Bool { return inTesting ? Environment.default.forceTest : false }
    
    // MARK:
    // MARK: Environment
    
    /// Only to be used for unit testing to force a test to run, @Warning DEBUG mode only
    mutating internal func forceTesting(_ closure: () -> Void) {
        defer { forceTest = false }
        
        forceTest = true
        
        closure()
    }
    
    /// Only to be used for unit testing to disable test checks, @Warning DEBUG mode only
    mutating internal func disableTestChecking(_ closure: () -> Void) {
        defer { disableTestCheck = false }
        
        disableTestCheck = true
        
        closure()
    }
    
    // MARK:
    // MARK: Initializers
    
    private init(forceTest: Bool) {
        
    }
    
    // MARK:
    // MARK: Private - Environment
    
    private let inDebug: Bool = {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }()
    
    private let inDEV: Bool = {
        #if DEBUG
            guard ProcessInfo.processInfo.environment[BuildType.DEV.rawValue] == "1" else { return false }
            
            return true
        #else
            return false
        #endif
    }()
    
    // MARK:
    // MARK: Private - Test
    
    private var inTesting: Bool {
        #if DEBUG
            guard !disableTestCheck else { return false }
            guard let testBundle = Bundle(identifier: "com.apple.dt.XCTest") else { return false }
            
            return Bundle.allFrameworks.contains(testBundle)
        #else
            return false
        #endif
    }
}
