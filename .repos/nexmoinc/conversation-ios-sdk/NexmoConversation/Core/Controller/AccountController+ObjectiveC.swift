//
//  AccountController+ObjectiveC.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 06/02/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

public extension AccountController {
    
    // MARK:
    // MARK: User (Objective-C compatibility support)

    /// Fetch user with a uuid
    ///
    /// - Parameters:
    ///   - uuid: user uuid
    ///   - onSuccess: user model
    ///   - onFailure: error
    @objc
    internal func user(with id: String, _ onSuccess: @escaping (UserModel) -> Void, onFailure: ((Error) -> Void)?) {
        user(with: id).subscribe(
            onNext: { user in onSuccess(user) },
            onError: { error in onFailure?(error) }
        ).addDisposableTo(disposeBag)
    }
}
