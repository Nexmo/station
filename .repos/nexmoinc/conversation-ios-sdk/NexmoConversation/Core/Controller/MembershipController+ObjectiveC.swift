//
//  MembershipController+ObjectiveC.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 01/02/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

internal extension MembershipController {
    
    // MARK:
    // MARK: Invite (Objective-C compatibility support)
    
    /// Invite user to a conversation
    ///
    /// - Parameters:
    ///   - user: user id
    ///   - id: conversation id
    ///   - onSuccess: success
    ///   - onFailure: error
    @objc
    internal func invite(user: String, toConversation id: String, _ onSuccess: @escaping () -> Void, onFailure: ((Error) -> Void)?) {
        invite(user: user, for: id).subscribe(
            onNext: { onSuccess() },
            onError: { error in onFailure?(error) }
        ).addDisposableTo(disposeBag)
    }
    
    // MARK:
    // MARK: Kick (Objective-C compatibility support)

    /// Kick user out of a conversation
    ///
    /// - Parameters:
    ///   - member: member id
    ///   - id: conversation id
    ///   - onSuccess: result
    ///   - onFailure: error
    @objc
    internal func kick(member: String, fromConversation id: String, _ onSuccess: @escaping (Bool) -> Void, onFailure: ((Error) -> Void)?) {
        kick(member, in: id).subscribe(
            onNext: { result in onSuccess(result) },
            onError: { error in onFailure?(error) }
        ).addDisposableTo(disposeBag)
    }
    
    // MARK:
    // MARK: Status (Objective-C compatibility support)
    
    /// Get details for a member in a conversation
    ///
    /// - Parameters:
    ///   - id: member id
    ///   - conversationId: conversation Id
    ///   - onSuccess: member model
    ///   - onFailure: error
    @objc
    @available(iOS, unavailable, message: "Only available in Swift")
    internal func detailsForMember(id: String, fromConversation conversationId: String, _ onSuccess: @escaping (Any) -> Void, onFailure: ((Error) -> Void)?) {
        // unavailable due to member object
    }
}
