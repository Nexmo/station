//
//  PushNotificationCertificate.swift
//  NexmoConversation
//
//  Created by shams ahmed on 16/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Gloss

/// APNS certificate model
public struct PushNotificationCertificate: Decodable {
    
    // MARK:
    // MARK: Properties
    
    /// Certificate
    public let certificate: String
    
    /// Password for certificate
    public let password: String?
    
    // MARK:
    // MARK: Initializers
    
    public init?(json: JSON) {
        guard let certificate: String = "token" <~~ json else { return nil }
        
        self.certificate = certificate
        self.password = "password" <~~ json
    }
}
