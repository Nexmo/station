//
//  Configuration.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 25/05/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/// Check if log level is higher then xyz..
///
/// - Parameters:
///   - lhs: log level
///   - rhs: log level
/// - Returns: result
internal func >=(lhs: Configuration.LogLevel, rhs: Configuration.LogLevel) -> Bool {
    switch (lhs, rhs) {
    case (.error, .error): return true
    case (.warning, .warning): return true
    case (.warning, .error): return true
    case (.info, .info): return true
    case (.none, .none): return true
    default: return false
    }
}

/// Client configuration
public struct Configuration {

    // MARK:
    // MARK: Enum

    /// Log level
    ///
    /// - none: Silent all logs from SDK
    /// - info: Output logs for information, warning and errors
    /// - `warning`: Output logs for warning and errors
    /// - error: Output logs for only errors
    public enum LogLevel {
        case none
        case info
        case warning
        case error
    }

    // MARK:
    // MARK: Default

    /// Global client configuration
    public static let `default`: Configuration = Configuration()

    // MARK:
    // MARK: Configurations

    /// Log level
    public let logLevel: LogLevel

    /// Auto reconnect
    public let autoReconnect: Bool
    
    // MARK:
    // MARK: Initializers
    
    public init(with logLevel: LogLevel = .warning, autoReconnect: Bool = true) {
        self.logLevel = logLevel
        self.autoReconnect = autoReconnect
    }
}
