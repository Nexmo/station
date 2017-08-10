//
//  ConversationRouter.swift
//  NexmoConversation
//
//  Created by shams ahmed on 03/10/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Alamofire

/// Router for conversation endpoints
internal enum ConversationRouter: URLRequestConvertible {
    
    /// API base url
    private static let baseURL = BaseURL.rest
    
    /// Create a conversation
    case create(model: Parameters?)
    
    /// Join a conversation with conversation uuid
    case join(uuid: String, parameters: Parameters?)
    
    /// Fetch all conversations for current user
    case all()
    
    /// Get a list of conversations this user is a member of.
    case allUser(id: String)
    
    /// Get full conversation details
    case conversation(id: String)
    
    // MARK:
    // MARK: Request
    
    private var method: HTTPMethod {
        switch self {
        case .create(_): return .post
        case .join(_, _): return .post
        case .all(): return .get
        case .allUser(_): return .get
        case .conversation(_): return .get
        }
    }
    
    private var path: String {
        switch self {
        case .create(_): return "/conversations"
        case .join(let uuid, _): return "/conversations/\(uuid)/members"
        case .all(): return "/conversations"
        case .allUser(let userId): return "/users/\(userId)/conversations"
        case .conversation(let id): return "/conversations/\(id)"
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
        case .create(let model):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: model)
        case .join(_, let model):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: model)
        case .all():
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .allUser(_):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .conversation(_):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        }
        
        return urlRequest
    }
}
