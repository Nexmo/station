//
//  ConversationClient+Private.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 07/11/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation

/// MARK: - Private methods that are not included in our framework, to be only used for testing
/// :nodoc:
public extension ConversationClient {
    
    // MARK:
    // MARK: Private - Testing: Token
    
    /// Private - Push Notification token
    ///
    /// - Returns: token
    /// :nodoc:
    public var deviceToken: String {
        guard case .registeredWithDeviceToken(let token) = appLifeCycleController.pushNotificationState else { return "" }
        
        return token.hexString
    }
    
    /// Private - Add Authorization token for testing, not stored in keychain
    /// :nodoc:
    public func addAuthorization(with token: String) {
        networkController.token = token
    }
    
    // MARK:
    // MARK: Private - Testing Helper
    
    /// Private - Leave all conversations
    /// :nodoc:
    internal func leaveAllConversations() {
        conversation.conversations.refetch()

        conversation.conversations.forEach {
            $0.leave().subscribe()
            .addDisposableTo(disposeBag)
        }
    }
}
