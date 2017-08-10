//
//  ConversationService.swift
//  NexmoConversation
//
//  Created by shams ahmed on 03/10/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Alamofire

/// Conversation service to handle all network request
internal struct ConversationService {

    /// Errors
    ///
    /// - invalidResponseFromBackend: Backend has a indexing lag, to avoid incomplete model wait a few seconds
    internal enum Errors: Error {
        case invalidResponseFromBackend
    }

    /// Network manager
    private let manager: HTTPSessionManager
    
    // MARK:
    // MARK: Initializers
    
    internal init(manager: HTTPSessionManager) {
        self.manager = manager
    }

    // MARK:
    // MARK: Create/Join
    
    /// Create a new conversation
    ///
    /// - Parameters:
    ///   - model: conversation parameters
    ///   - success: conversation uuid
    ///   - failure: failure
    /// - Returns: request
    @discardableResult
    internal func create(with model: ConversationController.CreateConversation, success: @escaping (String) -> Void, failure: @escaping (Error) -> Void) -> DataRequest {
        return manager
            .request(ConversationRouter.create(model: model.toJSON()))
            .validateAndReportError(to: manager)
            .responseJSON(queue: manager.queue, completionHandler: {
                switch $0.result {
                case .failure(let error):
                    failure(NetworkError(from: $0) ?? error)
                case .success(let response):
                    // TOOD: create model out of JSON
                    guard let json = response as? Parameters, let uuid = json["id"] as? String else {
                        return failure(HTTPSessionManager.Errors.malformedJSON)
                    }

                    success(uuid)
                }
            }
        )
    }
    
    /// Join a conversation user/member id
    ///
    /// - Parameters:
    ///   - model: join parameter
    ///   - uuid: conversation uuid
    ///   - success: success
    ///   - failure: failure
    /// - Returns: request
    @discardableResult
    internal func join(with model: ConversationController.JoinConversation, forUUID uuid: String, success: @escaping (MemberStatus) -> Void, failure: @escaping (Error) -> Void) -> DataRequest {
        return manager
            .request(ConversationRouter.join(uuid: uuid, parameters: model.toJSON()))
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
            }
        )
    }

    // MARK:
    // MARK: Conversations

    /// Fetch all lite conversation for current user
    ///
    /// - Parameters:
    ///   - success: lite conversation
    ///   - failure: failed reason
    /// - Returns: request
    @discardableResult
    internal func all(success: @escaping ([ConversationPreviewModel]) -> Void, failure: @escaping (Error) -> Void) -> DataRequest {
        return manager
            .request(ConversationRouter.all())
            .validateAndReportError(to: manager)
            .responseJSON(queue: manager.queue, completionHandler: {
                switch $0.result {
                case .failure(let error):
                    failure(NetworkError(from: $0) ?? error)
                case .success(let response):
                    guard let json = response as? [Parameters], let models = [ConversationPreviewModel].from(jsonArray: json) else {
                        return failure(HTTPSessionManager.Errors.malformedJSON)
                    }

                    success(models)
                }
            }
        )
    }
    
    /// Fetch all lite conversation for a user
    ///
    /// - Parameters:
    ///   - userId: id
    ///   - success: lite conversation
    ///   - failure: failed reason
    /// - Returns: request
    @discardableResult
    internal func all(for userId: String, success: @escaping ([ConversationPreviewModel]) -> Void, failure: @escaping (Error) -> Void) -> DataRequest {
        return manager
            .request(ConversationRouter.allUser(id: userId))
            .validateAndReportError(to: manager)
            .responseJSON(queue: manager.queue, completionHandler: {
                switch $0.result {
                case .failure(let error):
                    failure(NetworkError(from: $0) ?? error)
                case .success(let response):
                    guard let json = response as? [Parameters], let models = [ConversationPreviewModel].from(jsonArray: json) else {
                        return failure(HTTPSessionManager.Errors.malformedJSON)
                    }

                    success(models)
                }
            }
        )
    }

    // MARK:
    // MARK: Detailed Conversation

    /// Fetch a full detailed conversation
    ///
    /// - Parameters:
    ///   - cid: conversation
    ///   - success: conversation
    ///   - failure: failed reason
    /// - Returns: request
    @discardableResult
    internal func conversation(with cid: String, success: @escaping (ConversationModel) -> Void, failure: @escaping (Error) -> Void) -> DataRequest {
        return manager
            .request(ConversationRouter.conversation(id: cid))
            .validateAndReportError(to: manager)
            .responseJSON(queue: manager.queue, completionHandler: {
                switch $0.result {
                case .failure(let error):
                    failure(NetworkError(from: $0) ?? error)
                case .success(let response):
                    guard let json = response as? Parameters, let model = ConversationModel(json: json) else {
                        return failure(HTTPSessionManager.Errors.malformedJSON)
                    }

                    guard !model.members.isEmpty else { return failure(Errors.invalidResponseFromBackend) }
                    
                    success(model)
                }
            }
        )
    }
}
