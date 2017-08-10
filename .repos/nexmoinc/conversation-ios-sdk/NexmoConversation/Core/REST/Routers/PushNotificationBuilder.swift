//
//  PushNotificationBuilder.swift
//  NexmoConversation
//
//  Created by shams ahmed on 23/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Alamofire

/// Builder for making push notification request
internal struct PushNotificationBuilder {

    // MARK:
    // MARK: Builder
    
    /// Create payload for upload request
    internal static func uploadParameter(certificate: Data, password: String? = nil) -> Parameters {
        var parameters: Parameters = Parameters()
        
        if let token = String(data: certificate, encoding: .utf8) {
                parameters["token"] = token
        }
        
        if let password = password {
            parameters["password"] = password
        }
        
        return parameters
    }
    
    /// Create payload for update request
    internal static func updateParameter(token: Data) -> Parameters {
        return [
            "device_type": PushNotificationRouter.DeviceType.iOS.rawValue,
            "device_token": token.hexString
        ]
    }
}
