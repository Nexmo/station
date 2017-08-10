//
//  AuthenticationModel.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 05/12/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation

internal struct AuthenticationModel {
    
    /// HTTP status code
    internal let status: Int
    
    /// Auth token
    internal let token: String
    
    // MARK:
    // MARK: Initializers

    internal init?(json: Any) {
        guard let json = json as? [String : String] else { return nil }
        guard let statusString = json["status"], let status = Int(statusString), let token = json["token"] else { return nil }
        
        self.status = status
        self.token = token
    }
}
