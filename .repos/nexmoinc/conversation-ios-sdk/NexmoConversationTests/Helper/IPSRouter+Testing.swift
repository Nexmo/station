//
//  IPSRouter+Testing.swift
//  NexmoConversation
//
//  Created by shams ahmed on 03/12/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit
import Quick
import Nimble
import Mockingjay
import Alamofire
@testable import NexmoConversation

// MARK: - Unit test only
extension IPSRouter {
    
    // MARK:
    // MARK: URLRequestConvertible - Testing
    
    /// Build request
    internal func asURLRequest() throws -> URLRequest {
        let url = try type(of: self).baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .upload():
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: nil)
        }
        
        return urlRequest
    }
}
