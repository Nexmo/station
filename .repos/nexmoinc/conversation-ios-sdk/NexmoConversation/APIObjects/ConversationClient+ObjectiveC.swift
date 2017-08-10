//
//  ConversationClient+ObjectiveC.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 19/05/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

// MARK: - Objective-c support for conversation client
public extension ConversationClient {
    
    // MARK:
    // MARK: Enum - (Objective-C compatibility support)
    
    /// Global state of client
    ///
    /// - disconnected: Default state SDK has disconnected from all services. triggered on user logout/disconnects and inital state
    /// - connecting: Requesting permission to reconnect
    /// - connected: Connected to all services
    /// - outOfSync: SDK is not in sync yet
    /// - synchronizing: Synchronising with current progress state
    /// - synchronized: Synchronised all services and now ready
    @objc(NXMStateObjc)
    public enum StateObjc: Int {
        case disconnected
        case connecting
        case connected
        case outOfSync
        case synchronizing
        case synchronized
    }
    
    // MARK:
    // MARK: Observable (Objective-C compatibility support)
    
    /// Global state of client
    ///
    /// - Parameter closure: to listen for new state
    public func stateObjc(_ closure: @escaping (StateObjc) -> Void) {
        state.asDriver().asObservable().skip(1).subscribe(onNext: {
            switch $0 {
            case .disconnected: closure(.disconnected)
            case .connecting: closure(.connecting)
            case .connected: closure(.connected)
            case .outOfSync: closure(.outOfSync)
            case .synchronizing(_): closure(.synchronizing)
            case .synchronized: closure(.synchronized)
            }
        }).addDisposableTo(disposeBag)
    }
    
    // MARK:
    // MARK: Authentication (Objective-C compatibility support)
    
    /// Login using own token or cached token
    ///
    /// - parameter token: Token used to validate login
    /// - parameter callback: Response of login request, parameters with error optional
    public func login(with token: String?=nil, _ callback: @escaping LoginResponse) {
        guard let token = token ?? account.token else {
            callback(.invalidToken)
            
            return
        }

        let isNewTokenTheSame = token == networkController.token
        
        loginCallback = callback
        account.token = token // save to keychain
        networkController.token = token
        
        switch networkController.socketState.value {
        case .connected(_): return
        case .authentication: return
        case .connecting:
            guard !isNewTokenTheSame else { return }

            return socketController.login()
        default:
            break
        }
        
        // Connect to socket and login
        networkController.connect()
    }
}
