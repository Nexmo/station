//
//  Conversation+ObjectiveC.swift
//  NexmoConversation
//
//  Created by paul calver on 28/06/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/// Conversation - Objective-C compatibility support
public extension Conversation {

    /// Members
    public var membersObjc: [Member] { return members.map { $0 } }

    // MARK:
    // MARK: Leave - (Objective-C compatibility support)
    
    /// Leave current conversation
    ///
    /// - Parameters:
    ///   - onSuccess: method called upon completion of member leaving the conversation
    ///   - onFailure: method called upon failing to leave conversation
    @objc
    public func leave(onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        leave().subscribe(
            onSuccess: onSuccess,
            onError: onFailure
        ).addDisposableTo(disposeBag)
    }

    // MARK:
    // MARK: Join - (Objective-C compatibility support)

    /// Join current conversation
    ///
    /// - Parameters:
    ///   - onSuccess: method called upon completion of joining the conversation
    ///   - onFailure: method called upon failing to join conversation
    @objc
    public func join(onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        join().subscribe(
            onSuccess: onSuccess,
            onError: onFailure
        ).addDisposableTo(disposeBag)
    }

    // MARK:
    // MARK: Invite - (Objective-C compatibility support)

    /// Invite current conversation
    ///
    /// - Parameters:
    ///   - onSuccess: method called upon completion of inviting the conversation
    ///   - onFailure: method called upon failing to inviting conversation
    @objc
    public func invite(username: String, onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        invite(username).subscribe(
            onSuccess: onSuccess,
            onError: onFailure
        ).addDisposableTo(disposeBag)
    }
}
