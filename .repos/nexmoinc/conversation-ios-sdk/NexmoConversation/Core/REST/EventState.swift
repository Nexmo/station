//
//  EventState.swift
//  NexmoConversation
//
//  Created by James Green on 21/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Gloss

/// State of a event i.e sms, text, image 
internal class EventState: Decodable {
    
    internal var deliveredTo: [String: Date]?
    
    internal var seenBy: [String: Date]?
    
    internal var playDone: Bool?
    
    // MARK:
    // MARK: Initializers
    
    public required init?(json: JSON) {
        if let formatter = DateFormatter.ISO8601, let deliveredTo: [String:Date] = Decoder.decode(dateDictionaryForKey: "delivered_to", dateFormatter: formatter)(json) {
            self.deliveredTo = deliveredTo
        }
        
        if let formatter = DateFormatter.ISO8601, let seenBy: [String:Date] = Decoder.decode(dateDictionaryForKey: "seen_by", dateFormatter: formatter)(json) {
            self.seenBy = seenBy
        }
        
        self.playDone = "play_done" <~~ json
    }
}
