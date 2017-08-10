//
//  EventController+ObjectiveC.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 01/02/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

internal extension EventController {
    
    // MARK:
    // MARK: Retrieve (Objective-C compatibility support)
    
    /// Retrieve events with a range
    ///
    /// - Parameters:
    ///   - uuid: conversation uuid
    ///   - start: start index
    ///   - end: end index
    ///   - onSuccess: events
    ///   - onFailure: error
    @objc
    internal func retrieve(
        fromConversation uuid: String,
        start: Int,
        end: Int,
        _ onSuccess: @escaping ([Event]) -> Void,
        onFailure: ((Error) -> Void)?) {
        retrieve(for: uuid, with: Range<Int>(uncheckedBounds: (lower: start, upper: end))).subscribe(
            onNext: { events in onSuccess(events) },
            onError: { error in onFailure?(error) }
        ).addDisposableTo(disposeBag)
    }
}
