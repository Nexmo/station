//
//  WebSocketMessage.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 26/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/*
 Helper to do the common work for sending a message.
 */
internal struct WebSocketMessage {
    
    private let manager: WebSocketManager
    private let event: SocketService.Event
    private let json: [String: Any]
    
    // MARK:
    // MARK: Initializers
    
    internal init(_ message: [String: Any], forEvent event: SocketService.Event, on manager: WebSocketManager) {
        self.manager = manager
        self.event = event
        
        var message = message
        message["sdk"] = Constants.SDK.version
        
        json = [
            "tid": String(NSDate().timeIntervalSince1970),
            "body": message
        ]
    }
    
    // MARK:
    // MARK: Emit
    
    internal func emit() {
        manager.emit(event.rawValue, with: json)
    }
}
