//
//  File.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 05/12/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Alamofire

/// Router for auth example
internal enum AuthenticationRouter: URLRequestConvertible {
    
    /// Authenticate
    case authenticate(email: String, password: String)
    
    // MARK:
    // MARK: Request
    
    private var method: HTTPMethod {
        switch self {
        case .authenticate(_, _): return .post
        }
    }
    
    private var path: String {
        switch self {
        case .authenticate(_, _): return Constants.URL.acme
        }
    }
    
    // MARK:
    // MARK: URLRequestConvertible
    
    /// Build request
    internal func asURLRequest() throws -> URLRequest {
        let url = try path.asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .authenticate(let email, let password):
            urlRequest = try URLEncoding.default.encode(
                urlRequest,
                with: [
                    "email": email,
                    "password": password
                ]
            )
        }
        
        return urlRequest
    }
}
