//
//  AuthExample.swift
//  ConversationDemo
//
//  Created by James Green on 22/08/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import NexmoConversation
import Alamofire

/// Example of authenticating
internal struct AuthenticationService {
    
    internal enum Result {
        case success(AuthenticationModel)
        case failure(Error)
    }
    
    // MARK:
    // MARK: Authentication
    
    /// validate user
    ///
    /// - Parameters:
    ///   - email: email
    ///   - password: password
    ///   - result: response from auth server
    internal func validate(email: String, password: String, _ completion: @escaping (Result) -> Void) {
        SessionManager.default
            .request(AuthenticationRouter.authenticate(email: email, password: password))
            .validate()
            .responseJSON { response in
                guard case .success(let json) = response.result, let model = AuthenticationModel(json: json) else {
                    return completion(Result.failure(NSError(domain: "", code: -1)))
                }
                
                completion(Result.success(model))
        }
    }
}
