//
//  ConversationClient+Authentication.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 25/05/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import RxSwift

/// Authentication
public extension ConversationClient {
 
    // MARK:
    // MARK: Authentication
    
    /// Login
    ///
    /// - Parameter token: Token used to validate login
    /// - Returns: Response of login request
    @nonobjc
    public func login(with token: String?=nil) -> Single<Void> {
        return Single<Void>.create(subscribe: { [unowned self] observer in
            self.login(with: token, { result in
                switch result {
                case .success: return observer(SingleEvent.success(()))
                case .failed: return observer(SingleEvent.error(LoginResult.failed))
                case .invalidToken: return observer(SingleEvent.error(LoginResult.invalidToken))
                case .sessionInvalid: return observer(SingleEvent.error(LoginResult.sessionInvalid))
                case .expiredToken: return observer(SingleEvent.error(LoginResult.expiredToken))
                }
            })
            
            return Disposables.create()
        })
    }
    
    /// Log out user
    @discardableResult
    public func logout() -> Bool {
        if let deviceId = UIDevice.current.identifierForVendor?.uuidString {
            _ = account.removeDeviceToken(id: deviceId)
        }
        
        disconnect()
        
        // Clear persistent storage
        account.removeUserData()

        do {
            try databaseManager.clear()
        } catch _ {
            return false
        }
        
        objectCache.clear()
        conversation.conversations.refetch()

        account.state.value = .loggedOut
        
        return true
    }
}
