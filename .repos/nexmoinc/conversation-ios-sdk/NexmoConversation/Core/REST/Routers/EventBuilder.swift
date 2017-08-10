//
//  EventBuilder.swift
//  NexmoConversation
//
//  Created by shams ahmed on 03/10/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Alamofire

/// Build parameters for event request
internal enum EventBuilder {
    
    /// Send event with model payload
    case send(with: SendEvent)
    
    /// Conversations events
    case events(range: Range<Int>)
    
    /// Delete event
    case delete(with: String)
    
    // MARK:
    // MARK: Model
    
    /// Build parameters
    internal var parameters: Parameters {
        switch self {
        case .send(let model):
            return [
                "cid": model.conversationId,
                "from": model.from,
                "type": model.type.rawValue,
                "body": model.body
            ]
        case .events(let range):
            var parameter = ["start_id": range.lowerBound]
            
            if range.upperBound > 0 {
                parameter["end_id"] = range.upperBound
            }

            return parameter
        case .delete(let memberId):
            return ["from": memberId]
        }
    }
}
