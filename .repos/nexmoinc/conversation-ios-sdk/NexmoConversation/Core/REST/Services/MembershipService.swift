//
//  MembershipService.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 05/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Alamofire

/// Membership service to handle all network request
internal struct MembershipService {
    
    /// Network manager
    private let manager: HTTPSessionManager
    
    // MARK:
    // MARK: Initializers
    
    internal init(manager: HTTPSessionManager) {
        self.manager = manager
    }
    
    // MARK:
    // MARK: State
    
    /// Invite a user to a conversation
    ///
    /// - parameter username: username
    /// - parameter conversationId: conversation uuid
    /// - parameter success: success with event response model
    /// - parameter failure: failure
    ///
    /// - returns: request
    @discardableResult
    internal func invite(user id: String, conversationId: String, success: @escaping (MemberStatus) -> Void, failure: @escaping (Error) -> Void) -> DataRequest {
        return manager
            .request(MembershipRouter.invite(id: id, conversationId: conversationId))
            .validateAndReportError(to: manager)
            .responseJSON(queue: manager.queue, completionHandler: {
                switch $0.result {
                case .failure(let error):
                    failure(NetworkError(from: $0) ?? error)
                case .success(let response):
                    guard let json = response as? Parameters, let model = MemberStatus(json: json) else {
                        return failure(HTTPSessionManager.Errors.malformedJSON)
                    }
                    
                    success(model)
                }
            })
    }
    
    /// Invite a user to a conversation
    ///
    /// - parameter username: username
    /// - parameter conversationId: conversation uuid
    /// - parameter success: success with event response model
    /// - parameter failure: failure
    ///
    /// - returns: request
    @discardableResult
    internal func kick(_ memberId: String, in conversationId: String, success: @escaping (Bool) -> Void, failure: @escaping (Error) -> Void) -> DataRequest {
        return manager
            .request(MembershipRouter.kick(conversationId: conversationId, memberId: memberId))
            .validateAndReportError(to: manager)
            .response(completionHandler: {
                guard $0.error == nil else { return failure(NetworkError(from: $0)) }

                success(true)
            })
    }
    
    // MARK:
    // MARK: Details
    
    /// Fetch member detail for a conversation
    ///
    /// - parameter for: member id
    /// - parameter in: conversation uuid
    /// - parameter success: success with member model
    /// - parameter failure: failure
    ///
    /// - returns: request
    @discardableResult
    internal func details(for member: String, in conversationId: String, success: @escaping (MemberModel) -> Void, failure: @escaping (Error) -> Void) -> DataRequest {
        return manager
            .request(MembershipRouter.details(conversationId: conversationId, memberId: member))
            .validateAndReportError(to: manager)
            .responseJSON(queue: manager.queue, completionHandler: {
                switch $0.result {
                case .failure(let error):
                    failure(NetworkError(from: $0) ?? error)
                case .success(let response):
                    guard let json = response as? Parameters, let model = MemberModel(json: json) else {
                        return failure(HTTPSessionManager.Errors.malformedJSON)
                    }

                    success(model)
                }
            }
        )
    }
}
