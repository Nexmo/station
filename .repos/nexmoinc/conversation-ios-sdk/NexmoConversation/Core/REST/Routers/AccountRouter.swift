//
//  AccountRouter.swift
//  NexmoConversation
//
//  Created by shams ahmed on 19/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Alamofire

/// Router for account endpoints
internal enum AccountRouter: URLRequestConvertible {
    
    /// API base url
    private static let baseURL = BaseURL.rest
    
    /// fetch user model
    case user(id: String)
    
    // MARK:
    // MARK: Request
    
    private var method: HTTPMethod {
        switch self {
        case .user(_): return .get
        }
    }
    
    private var path: String {
        switch self {
        case .user(let id): return "/users/\(id)"
        }
    }
    
    // MARK:
    // MARK: URLRequestConvertible
    
    /// Build request
    internal func asURLRequest() throws -> URLRequest {
        let url = try type(of: self).baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .user(_):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: nil)
        }
        
        return urlRequest
    }
}
