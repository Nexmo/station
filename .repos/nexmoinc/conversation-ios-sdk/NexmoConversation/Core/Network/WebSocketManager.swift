//
//  WebSocketManager.swift
//  NexmoConversation
//
//  Created by James Green on 25/08/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import SocketIO
import RxSwift

/// Manager for conecting socket
internal class WebSocketManager {
    
    /// Socket state
    ///
    /// - notConnected: socket not connected
    /// - disconnected: socket has been disconnected
    /// - connecting: connecting to capi socket
    /// - connected: connected to capi with token
    internal enum State: Equatable {
        
        /// Status reason
        ///
        /// - timeout: socket timedout
        /// - connectionLost: lost connection due to bad network
        /// - sessionInvalid: session is not valid any more
        /// - invalidToken: bad credentials provided
        /// - expiredToken: token has expired
        /// - unknown: unknown error with raw socket response
        internal enum Reason: Equatable {
            case timeout
            case connectionLost
            case sessionInvalid
            case invalidToken
            case expiredToken
            case unknown([Any])
        }
        
        case notConnected(Reason)
        case disconnected
        case connecting
        case authentication
        case connected(Session)
    }
    
    /// SocketIOClient
    private let websocket: SocketIOClient = {
        // fatal error is fine here, stop app if contants is badly formatted
        guard let url = URL(string: BaseURL.socket) else { fatalError("Socket URL not in there correct format") }
        
        return SocketIOClient(socketURL: url, config: SocketConfiguration.withLogging(false))
    }()

    /// An event to indicate our socket status.
    internal let state: Variable<State> = Variable<State>(.notConnected(.unknown([])))
    
    /// Processing events queue
    internal let queue: DispatchQueue
    
    // MARK:
    // MARK: Initializers
    
    internal init(queue: DispatchQueue) {
        self.queue = queue
    }
    
    // MARK:
    // MARK: Connect/Disconnect
    
    /// Open socket
    internal func connect() {
        guard websocket.status != .connecting else { return }

        websocket.connect(timeoutAfter: 30, withHandler: nil)
    }
    
    /// Close socket
    internal func close() {
        websocket.disconnect()
    }
    
    // MARK:
    // MARK: Listener
    
    /// Subscribe to a event
    internal func on(_ event: String, _ listener: @escaping ([Any]) -> Void) {
        websocket.on(event) { (data, _) in listener(data) }
    }
    
    // MARK:
    // MARK: Emit
    
    /// Send a event
    internal func emit(_ event: String, with json: [String: Any]) {
        websocket.emit(event, json)
    }
    
    // MARK:
    // MARK: Testing
    
    /// Only for testing, help validate internal listeners
    ///
    /// - Parameters:
    ///   - event: event name
    ///   - data: payload
    internal func testListener(_ event: String, with data: [Any]) {
        websocket.handleEvent(event, data: data, isInternalMessage: true)
    }
}

// MARK:
// MARK: Compare

internal func ==(lhs: WebSocketManager.State, rhs: WebSocketManager.State) -> Bool {
    switch (lhs, rhs) {
    case (.connected(_), .connected(_)): return true
    case (.connecting, .connecting): return true
    case (.disconnected, .disconnected): return true
    case (.notConnected(_), .notConnected(_)): return true
    case (.authentication, .authentication): return true
    case (.connected, _),
         (.connecting, _),
         (.authentication, _),
         (.disconnected, _),
         (.notConnected, _): return false
    }
}

internal func ==(lhs: WebSocketManager.State.Reason, rhs: WebSocketManager.State.Reason) -> Bool {
    switch (lhs, rhs) {
    case (.unknown(_), .unknown(_)): return true
    case (.connectionLost, .connectionLost): return true
    case (.timeout, .timeout): return true
    case (.sessionInvalid, .sessionInvalid): return true
    case (.invalidToken, .invalidToken): return true
    case (.expiredToken, .expiredToken): return true
    case (.unknown, _),
         (.connectionLost, _),
         (.timeout, _),
         (.sessionInvalid, _),
         (.invalidToken, _),
         (.expiredToken, _): return false
    }
}
