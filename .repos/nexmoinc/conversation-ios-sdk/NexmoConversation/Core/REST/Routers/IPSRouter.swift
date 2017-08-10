//
//  IPSRouter.swift
//  NexmoConversation
//
//  Created by shams ahmed on 29/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Alamofire

/// Router for Image Process Service
internal enum IPSRouter: URLRequestConvertible {
    
    /// API base url
    internal static let baseURL = BaseURL.ips
    
    /// Upload a image to IPS
    case upload()
  
    // MARK:
    // MARK: Request
    
    internal var method: HTTPMethod {
        // Side note: must be internal for testing
        switch self {
        case .upload(): return .post
        }
    }
    
    internal var path: String {
        // Side note: must be internal for testing
        switch self {
        case .upload(): return "/image"
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
        case .upload():
            // For unit test purposes :(
            if Environment.inDebug, Environment.inTesting, ConversationClient.instance.networkController.token == "Test Mode" {
                throw HTTPSessionManager.Errors.malformedJSON
            }
            
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: nil)
        }
        
        return urlRequest
    }
}
