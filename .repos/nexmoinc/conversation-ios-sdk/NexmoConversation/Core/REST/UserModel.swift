//
//  UserModel.swift
//  NexmoConversation
//
//  Created by James Green on 01/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Gloss

// User model
internal class UserModel: UserLiteModel {
    
    /// Display Name
    internal var displayName: String
    
    /// Avatar
    internal var imageUrl: String
    
    /// Channel for account actions
    internal var channels: AnyObject?
    
    // MARK:
    // MARK: Initializers

    internal init(displayName: String, imageUrl: String, uuid: String, name: String) {
        self.displayName = displayName
        self.imageUrl = imageUrl
        
        super.init(uuid: uuid, name: name)
    }
    
    internal required init?(json: JSON) {
        if let displayName: String = "display_name" <~~ json {
            self.displayName = displayName
        } else {
            self.displayName = ""
        }
        
        if let imageUrl: String = "image_url" <~~ json {
            self.imageUrl = imageUrl
        } else {
            self.imageUrl = ""
        }
        
        super.init(json: json)
    }
}
