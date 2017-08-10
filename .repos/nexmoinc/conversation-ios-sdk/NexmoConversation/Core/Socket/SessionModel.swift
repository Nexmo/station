//
//  SessionModel.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 26/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Gloss

/// Session message
internal struct SessionModel: Decodable {
    
    /// session id
    let id: String
    
    /// Current user id
    let userId: String
    
    /// Username
    let name: String
    
    // MARK:
    // MARK: JSON
    
    init?(json: JSON) {
        guard let id: String = "body.id" <~~ json,
            let userId: String = "body.user_id" <~~ json,
            let name: String = "body.name" <~~ json else {
            return nil
        }
        
        self.id = id
        self.userId = userId
        self.name = name
    }
}
