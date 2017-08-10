//
//  MembershipRouter.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 05/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Alamofire

/// Router for membership endpoints
internal enum MembershipRouter: URLRequestConvertible {
    
    /// API base url
    private static let baseURL = BaseURL.rest
    
    /// Invite user to a conversation
    case invite(id: String, conversationId: String)
    
    /// Get member details
    case details(conversationId: String, memberId: String)
    
    /// Kick a user out of a conversation
    case kick(conversationId: String, memberId: String)
    
    // MARK:
    // MARK: Request
    
    private var method: HTTPMethod {
        switch self {
        case .invite(_, _): return .post
        case .details(_, _): return .get
        case .kick(_, _): return .delete
        }
    }
    
    private var path: String {
        switch self {
        case .invite(_, let conversationId): return "/conversations/\(conversationId)/members"
        case .details(let conversationId, let memberId): return "/conversations/\(conversationId)/members/\(memberId)"
        case .kick(let conversationId, let memberId): return "/conversations/\(conversationId)/members/\(memberId)"
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
        case .invite(let id, _):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: MembershipBuilder.invite(id: id).parameters)
        case .details(_, _):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .kick(_, _):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        }
        
        return urlRequest
    }
}
