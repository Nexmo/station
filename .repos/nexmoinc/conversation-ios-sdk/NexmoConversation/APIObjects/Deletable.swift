//
//  Deletable.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 27/03/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/// Delete event
public protocol Deletable {
    
}

public extension Deletable where Self: TextEvent {

    // MARK:
    // MARK: Delete

    /// Delete event
    ///
    /// - Returns: if event is scheduled to be deleted
    public func delete() -> Bool {
        return conversation.delete(self)
    }
}
