//
//  ConversationController+ObjectiveC.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 31/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

public extension ConversationController {

    // MARK:
    // MARK: Properties - (Objective-C compatibility support)
    
    /// List of conversations, only for Objective-c suppoty
    public var conversationsObjc: [Conversation] {
        return self.conversations.map { $0 }
    }
    
    // MARK:
    // MARK: Create (Objective-C compatibility support)
    
    /// Create a new conversation
    ///
    /// - Parameters:
    ///   - name: conversation display name
    ///   - onSuccess: uuid of new conversation
    ///   - onFailure: error
    @objc
    public func new(with name: String, _ onSuccess: @escaping (Conversation) -> Void, onFailure: ((Error) -> Void)?) {
        let conversation = ConversationController.CreateConversation(name: name)
        
        new(conversation).subscribe(
            onNext: { onSuccess($0) },
            onError: { onFailure?($0) }
        ).addDisposableTo(disposeBag)
    }
    
    /// Create a new conversation and join with user id
    ///
    /// - Parameters:
    ///   - name: conversation display name
    ///   - userId: userid of the user wants to join
    ///   - onSuccess: member state
    ///   - onFailure: error
    @objc
    public func new(with name: String, shouldJoin: Bool, _ onSuccess: @escaping (Conversation) -> Void, onFailure: ((Error) -> Void)?) {
        let conversation = ConversationController.CreateConversation(name: name)
        
        new(conversation, withJoin: shouldJoin).subscribe(
            onNext: { onSuccess($0) },
            onError: { onFailure?($0)
        }).addDisposableTo(disposeBag)
    }
    
    // MARK:
    // MARK: Fetch (Objective-C compatibility support)
    
    /// Fetch a conversation
    ///
    /// - Parameters:
    ///   - id: conversation Id
    ///   - onSuccess: conversation model
    ///   - onFailure: error
    @objc
    public func conversation(with id: String, _ onSuccess: @escaping (Conversation) -> Void, onFailure: ((Error) -> Void)?) {
        conversation(with: id).subscribe(
            onNext: { conversation in onSuccess(conversation) },
            onError: { error in onFailure?(error) }
        ).addDisposableTo(disposeBag)
    }

    /// Fetch all conversations
    ///
    /// - Parameters:
    ///   - onSuccess: all conversation lite models
    ///   - onFailure: error
    @objc
    public func all(_ onSuccess: @escaping ([ConversationPreviewModel]) -> Void, onFailure: ((Error) -> Void)?) {
        all().subscribe(
            onNext: { conversations in onSuccess(conversations) },
            onError: { error in onFailure?(error) }
        ).addDisposableTo(disposeBag)
    }
    
    /// Fetch all users conversations
    ///
    /// - Parameters:
    ///   - userId: user id
    ///   - onSuccess: all user conversation
    ///   - onFailure: error
    @objc
    public func all(with userId: String, _ onSuccess: @escaping ([ConversationPreviewModel]) -> Void, onFailure: ((Error) -> Void)?) {
        all(with: userId).subscribe(
            onNext: { conversations in onSuccess(conversations) },
            onError: { error in onFailure?(error) }
        ).addDisposableTo(disposeBag)
    }
    
    // MARK:
    // MARK: Join (Objective-C compatibility support)
    
    /// Join a conversation
    ///
    /// - Parameters:
    ///   - userId: user id
    ///   - memberId: member id
    ///   - uuid: conversation id
    ///   - onSuccess: member state
    ///   - onFailure: error
    @objc
    internal func join(userId: String, memberId: String?, uuid: String, _ onSuccess: @escaping (String) -> Void, onFailure: ((Error) -> Void)?) {
        let conversation = JoinConversation(userId: userId, memberId: memberId)
        
        join(conversation, forUUID: uuid).subscribe(onNext: { state in
            onSuccess(state.rawValue)
        }, onError: { error in
            onFailure?(error)
        }).addDisposableTo(disposeBag)
    }
}
