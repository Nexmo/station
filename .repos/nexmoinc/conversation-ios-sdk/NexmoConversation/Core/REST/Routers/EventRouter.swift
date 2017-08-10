//
//  EventRouter.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 04/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Alamofire

/// Router for event endpoints
internal enum EventRouter: URLRequestConvertible {
    
    /// API base url
    private static let baseURL = BaseURL.rest
    
    /// Send a event
    case send(event: SendEvent)
    
    /// Get events with a range
    case events(conversationUuid: String, range: Range<Int>)
    
    /// Delete a event
    case delete(eventId: Int, conversationUuid: String, memberId: String)
    
    // MARK:
    // MARK: Request
    
    private var method: HTTPMethod {
        switch self {
        case .send(_): return .post
        case .events(_, _): return .get
        case .delete(_, _, _): return .delete
        }
    }
    
    private var path: String {
        switch self {
        case .send(let event): return "/conversations/\(event.conversationId)/events"
        case .events(let conversationUuid, _): return "/conversations/\(conversationUuid)/events"
        case .delete(let eventId, let conversationUuid, _): return "conversations/\(conversationUuid)/events/\(eventId)"
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
        case .send(let event):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: EventBuilder.send(with: event).parameters)
        case .events(_, let range):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: EventBuilder.events(range: range).parameters)
        case .delete(_, _, let memberId):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: EventBuilder.delete(with: memberId).parameters)
        }
        
        return urlRequest
    }
}
