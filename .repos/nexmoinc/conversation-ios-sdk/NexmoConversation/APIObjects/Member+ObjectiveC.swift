//
//  Member+ObjectiveC.swift
//  NexmoConversation
//
//  Created by paul calver on 28/06/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/// Member - Objective-C compatibility support
public extension Member {
    
    // MARK:
    // MARK: Kick - (Objective-C compatibility support)
    
    /// Kick member out of this conversation
    ///
    /// - Parameters:
    ///   - onSuccess: success operation
    ///   - onFailure: failed operation
    @objc
    public func kick(onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        kick().subscribe(
            onSuccess: onSuccess,
            onError: onFailure
        ).addDisposableTo(disposeBag)
    }
}
