//
//  SessionConfiguration.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 01/11/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation

/// URL Configuration for CAPI
@objc
internal class SessionConfiguration: NSObject {
    
    /// Configuration
    private let configuration = URLSessionConfiguration.default
    
    // MARK:
    // MARK: Default

    /// Default configuration for CAPI
    internal static var `default`: URLSessionConfiguration { return SessionConfiguration().configuration }
    
    // MARK:
    // MARK: Initializers
    
    private override init() {
        super.init()
        
        setup(configuration)
    }
    
    // MARK:
    // MARK: Private 
    
    @discardableResult
    @objc
    private dynamic func setup(_ configuration: URLSessionConfiguration) -> URLSessionConfiguration {
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 20
        
        return configuration
    }
}
