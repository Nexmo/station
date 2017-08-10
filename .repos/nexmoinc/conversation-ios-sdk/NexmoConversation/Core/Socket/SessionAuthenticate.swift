//
//  SessionAuthenticate.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 27/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Gloss

/// Authenticate to CAPI
internal struct SessionAuthenticate: Encodable {

    /// Device type
    let device = PushNotificationRouter.DeviceType.iOS.rawValue
    
    /// Device id
    let deviceId: String = UIDevice.current.identifierForVendor?.uuidString ?? ""
    
    /// Auth token
    let token: String
    
    // MARK:
    // MARK: Initializers
    
    init(token: String) {
        self.token = token
    }
    
    // MARK:
    // MARK: JSON
    
    func toJSON() -> JSON? {
        return [
            "device_type": device,
            "device_id": deviceId,
            "token": token
        ]
    }
}
