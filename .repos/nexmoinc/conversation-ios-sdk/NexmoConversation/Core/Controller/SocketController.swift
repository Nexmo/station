//
//  SocketController.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 13/02/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

internal struct SocketController {
    
    private let socketService: SocketService
    
    private let subscriptionService: SubscriptionService
    
    // MARK:
    // MARK: Initializers
    
    internal init(socketService: SocketService, subscriptionService: SubscriptionService) {
        self.socketService = socketService
        self.subscriptionService = subscriptionService
    }
    
    // MARK:
    // MARK: Login
    
    /// Make request to login to CAPI
    internal func login() {
        socketService.login()
    }
}
