//
//  WebSocketLogger.swift
//  NexmoConversation
//
//  Created by shams ahmed on 09/03/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import SocketIO

/// Web socket logger
internal class WebSocketLogger: SocketLogger {
    
    /// Enable/disable logs
    internal var log: Bool = true
    
    // MARK:
    // MARK: Logging
    
    /// Verbose log
    internal func log(_ message: String, type: String, args: Any...) {
        switch message {
        case "Adding engine": return
        case "Starting engine. Server: %@": return
        case "Handshaking": return
        case "Sending ws: %@ as type: %@": return
        case "Should parse message: %@": return
        case "Adding handler for event: %@": return
        case "Emitting: %@": return
        case "Writing ws: %@": return
        case "Engine is being closed.": return
        case "Got message: %@": return
        case "Writing ws: %@ has data: %@": return
        case "Parsing %@": return
        case "Decoded packet as: %@": return
        case "Handling event: %@ with data: %@" where (args[0] as? String) == "disconnect": return
        case "Handling event: %@ with data: %@" where (args[0] as? String) == "connect": return
        case "Handling event: %@ with data: %@" where (args[0] as? String) == "text:typing:off":
            printLog("Handling event: %@", type, ["text:typing:off", ""])
        case "Handling event: %@ with data: %@" where (args[0] as? String) == "text:typing:on":
            printLog("Handling event: %@", type, ["text:typing:on", ""])
        case "Handling event: %@ with data: %@" where (args[0] as? String) == "text:delivered":
            printLog("Handling event: %@", type, ["text:delivered", ""])
        case "Handling event: %@ with data: %@" where (args[0] as? String) == "text:seen":
            printLog("Handling event: %@", type, ["text:seen", ""])
        case "Handling event: %@ with data: %@" where (args[0] as? String) == "statusChange":
            switch args[1] as? SocketIOClientStatus {
            case .notConnected?: printLog("Handling event: %@", type, ["notConnected", ""])
            case .disconnected?: printLog("Handling event: %@", type, ["disconnected", ""])
            case .connecting?: printLog("Handling event: %@", type, ["connecting", ""])
            default: return
            }
        case "session:success": return
        case "Closing socket": return
        case "Disconnected": return
        case "Connect": return
        default: printLog(message, type, args)
        }
    }
    
    /// Error log
    internal func error(_ message: String, type: String, args: Any...) {
         printLog(message, type, args)
    }
    
    // MARK:
    // MARK: Print
    
    /// Print log
    ///
    /// - Parameters:
    ///   - message: text
    ///   - type: type of event from socket
    ///   - args: extra argments
    private func printLog(_ message: String, _ type: String, _ args: [Any]) {
        guard log else { return }
        
        let newArgs = args.map { arg -> CVarArg in String(describing: arg) }
        let messageFormat = String(format: message, arguments: newArgs)
        
        Log.info(.other, "\(type): \(messageFormat)")
    }
}
