//
//  Session.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 26/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Gloss

/// Session
public struct Session: Decodable {
    
    // MARK:
    // MARK: Properties
    
    /// Session id
    public let id: String
    
    /// User id
    public let userId: String
    
    /// Username/Email
    public let name: String
    
    // MARK:
    // MARK: JSON
    
    public init?(json: JSON) {
        guard let id: String = "body.id" <~~ json,
            let userId: String = "body.user_id" <~~ json,
            let name: String = "body.name" <~~ json else {
            return nil
        }
        
        self.id = id
        self.userId = userId
        self.name = name
    }
    
    internal init(id: String, userId: String, name: String) {
        self.id = id
        self.name = name
        self.userId = userId
    }
}
