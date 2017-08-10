//
//  MembershipBuilder.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 05/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Alamofire

/// Build parameters for membership request
internal enum MembershipBuilder {
    
    /// Build invite request
    case invite(id: String)
    
    // MARK:
    // MARK: Model
    
    /// Build parameters
    internal var parameters: Parameters {
        switch self {
        case .invite(let id):
            return [
                "user_name": id,
                "action": MemberModel.Action.invite.rawValue,
                "channel": ["type": MemberModel.Channel.app.rawValue]
                ]
        }
    }
}
