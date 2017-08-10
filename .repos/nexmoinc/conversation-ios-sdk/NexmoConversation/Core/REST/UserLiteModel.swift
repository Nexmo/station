//
//  UserLiteModel.swift
//  NexmoConversation
//
//  Created by James Green on 01/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Gloss

/// Light mode lof user coming from socket
internal class UserLiteModel: NSObject, Decodable {
    
    /// ID of the corresponding User
    internal var uuid: String
    
    /// The unique name for this User
    internal var name: String

    // MARK:
    // MARK: Initializers

    internal init(uuid: String, name: String) {
        self.uuid = uuid
        self.name = name
    }
    
    internal required init?(json: JSON) {
        guard let uuid: String = "id" <~~ json else { return nil }
        guard let name: String = "name" <~~ json else { return nil }
        
        self.uuid = uuid
        self.name = name
    }
}
