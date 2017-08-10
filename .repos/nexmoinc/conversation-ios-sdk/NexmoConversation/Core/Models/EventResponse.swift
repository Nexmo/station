//
//  EventResponse.swift
//  NexmoConversation
//
//  Created by shams ahmed on 11/10/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Gloss

/// Response model from making a event request
internal struct EventResponse: Decodable {
    
    /// ID of event from backend side
    internal let id: Int
    
    /// Internal link used for primary id from backend database
    internal let href: String
    
    /// Timestamp of event
    internal let timestamp: Date
    
    // MARK:
    // MARK: Initializers
    
    internal init?(json: JSON) {
        guard let id: Int = "id" <~~ json else { return nil }
        guard let href: String = "href" <~~ json else { return nil }
        
        guard let formatter = DateFormatter.ISO8601,
            let timestamp: Date = Decoder.decode(dateForKey: "timestamp", dateFormatter: formatter)(json) else {
            return nil
        }
        
        self.id = id
        self.href = href
        self.timestamp = timestamp
    }
}
