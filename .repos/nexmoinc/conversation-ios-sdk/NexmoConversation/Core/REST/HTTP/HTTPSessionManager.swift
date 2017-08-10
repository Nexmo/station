//
//  HTTPSessionManager.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 01/11/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

/// HTTP Session manager
internal class HTTPSessionManager: SessionManager {
    
    /// Error state
    ///
    /// - requestFailed: bad request with error message
    /// - malformedJSON: bad json
    /// - cancelled: cancelled due to network or task
    internal enum Errors: Error {
        case requestFailed(error: Any?)
        case malformedJSON
        case cancelled
        case invalidToken
    }
    
    /// Common keys for http header
    ///
    /// - authorization: authorization
    internal enum HeaderKeys: String {
        case authorization = "Authorization"
    }
    
    internal let queue: DispatchQueue
    internal let errorListener: Variable<NetworkErrorProtocol?> = Variable<NetworkErrorProtocol?>(nil)
    internal let reachabilityManager = ReachabilityManager()
    
    // MARK:
    // MARK: Initializers
    
    internal init(queue: DispatchQueue) {
        self.queue = queue
        
        // TODO: Add SSL pinning support
        super.init(
            configuration: SessionConfiguration.default,
            delegate: SessionDelegate(),
            serverTrustPolicyManager: nil
        )
        
        setup()
    }
    
    // MARK:
    // MARK: Setup
    
    private func setup() {
        retrier = RequestRetry()
        adapter = AuthorizationAdapter()
    }
}
