//
//  Log.swift
//  NexmoConversation
//
//  Created by James Green on 22/08/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation

/// Logger
internal struct Log {

    /// Logger Module
    internal enum Module: String {
        case rest = "REST"
        case websocket = "WebSocket"
        case socketIO = "Socket IO Library"
        case syncManager = "Sync Manager"
        case database = "Database"
        case eventProcessor = "Event Processor"
        case taskProcessor = "Task Processor"
        case signals = "Signal"
        case other = ""
    }

    // MARK:
    // MARK: Logger

    /// Print console log for info message
    ///
    /// - Parameters:
    ///   - module: module type
    ///   - message: message to print
    internal static func info(_ module: Module = .other, _ message: String) {
        // TODO: Add new table in db for configuration
        guard ConversationClient.configuration.logLevel >= .info else { return }

        printValue(module, message)
    }

    /// Print console log for warning message
    ///
    /// - Parameters:
    ///   - module: module type
    ///   - message: message to print
    internal static func warn(_ module: Module = .other, _ message: String) {
        // TODO: Add new table in db for configuration
        guard ConversationClient.configuration.logLevel >= .warning else { return }

        printValue(module, message)
    }

    /// Print console log for error message
    ///
    /// - Parameters:
    ///   - module: module type
    ///   - message: message to print
    internal static func error(_ module: Module = .other, _ message: String) {
        // TODO: Add new table in db for configuration
        guard ConversationClient.configuration.logLevel >= .error else { return }

        printValue(module, message)
    }

    // MARK:
    // MARK: Print

    /// Print
    private static func printValue(_ module: Module = .other, _ message: String) {
        // TODO: Add new table in db for configuration
        if case .other = module {
            print(message)

            return
        }

        print(module.rawValue + ": " + message)
    }
}
