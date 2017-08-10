//
//  SocketService.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 25/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/// Service for socket-io events
internal class SocketService {
    
    internal enum Event: String {
        case disconnect
        case disconnecting
        case disconnected
        case connect
        case newListener
        case removeListener
        case error
        case reconnect
        case reconnectAttempt
        case timeout
        case sessionSuccess = "session:success"
        case sessionInvalid = "session:invalid"
        case invalidToken = "system:error:invalid-token"
        case expiredToken = "system:error:expired-token"
        case badPermission = "system:error:permission"
        case invalidEvent = "system:error:invalid-event"
        case sessionLogin = "session:login"
    }
    
    /// Socket manager
    private let webSocketManager: WebSocketManager
    
    /// Token
    internal var token = ""
    
    // MARK:
    // MARK: Initializers
    
    internal init(webSocketManager: WebSocketManager) {
        self.webSocketManager = webSocketManager
        
        setup()
    }
    
    // MARK:
    // MARK: Setup
    
    private func setup() {
        webSocketManager.on(Event.disconnect.rawValue) { _ in self.updateState(with: .disconnected) }
        webSocketManager.on(Event.disconnected.rawValue) { _ in self.updateState(with: .disconnected) }
        webSocketManager.on(Event.connect.rawValue) { _ in self.login() }
        webSocketManager.on(Event.timeout.rawValue) { _ in self.updateState(with: .notConnected(.timeout)) }
        webSocketManager.on(Event.reconnect.rawValue) { _ in self.updateState(with: .connecting) }
        webSocketManager.on(Event.sessionSuccess.rawValue) { self.validate($0) }
        webSocketManager.on(Event.sessionInvalid.rawValue) { _ in self.updateState(with: .notConnected(.sessionInvalid)) }
        webSocketManager.on(Event.invalidToken.rawValue) { _ in self.updateState(with: .notConnected(.invalidToken)) }
        webSocketManager.on(Event.expiredToken.rawValue) { _ in self.updateState(with: .notConnected(.expiredToken)) }
        webSocketManager.on(Event.badPermission.rawValue) { self.updateState(with: .notConnected(.unknown($0))) }
        
        webSocketManager.on(Event.error.rawValue) { data in
            Log.info(.websocket, "Event: \(Event.error.rawValue)")
            
            self.updateState(with: .notConnected(.unknown(data)))
        }
        
        webSocketManager.on(Event.invalidEvent.rawValue) { _ in
            Log.info(.websocket, "Event: \(Event.invalidEvent.rawValue)")
        }
    }
    
    // MARK:
    // MARK: Validation
    
    /// Valid session response
    ///
    /// - Parameter data: raw session
    /// - Returns: result
    @discardableResult
    internal func validate(_ response: [Any]) -> Bool {
        guard let json = response.first as? [String: AnyObject], let model = Session(json: json) else { return false }
        
        updateState(with: .connected(model))
        
        return true
    }
    
    // MARK:
    // MARK: Session
    
    /// Request login
    ///
    /// - Returns: result
    @discardableResult
    internal func login() -> Bool {
        guard !token.isEmpty,
            let message = SessionAuthenticate(token: token).toJSON() else {
            updateState(with: .notConnected(.invalidToken))
            
            return false
        }

        updateState(with: .authentication)
        
        WebSocketMessage(message, forEvent: .sessionLogin, on: webSocketManager).emit()
        
        return true
    }
    
    /// Update State and close connection
    internal func updateState(with state: WebSocketManager.State) {
        webSocketManager.state.value = state
    }
}
