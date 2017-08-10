//
//  Change.swift
//  NexmoConversation
//
//  Created by shams ahmed on 12/07/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/// Change of collection
///
/// - inserted: Inserted new T object into collection
/// - updated: Updated existing T object into collection
/// - deleted: Deleted T object from collection
public enum Change<T, S> {
    case inserted([T], S)
    case updated([T])
    case deleted([T])
}
