//
//  JoinConversation.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 05/12/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Gloss

/// Request model
public extension ConversationController {

    // MARK:
    // MARK: Model

    /// Join a conversation request
    public struct JoinConversation: Encodable {
        
        // MARK:
        // MARK: Properties
        
        /// user id
        public let userId: String
        
        /// action to perform
        private let action = MemberModel.Action.join
        
        /// channel
        private let channel = ["type": MemberModel.Channel.app.rawValue]
        
        /// member whom want to join, can be nil value
        public let memberId: String?
        
        // MARK:
        // MARK: Initializers

        public init(userId: String, memberId: String?=nil) {
            self.userId = userId
            self.memberId = memberId
        }
        
        // MARK:
        // MARK: JSON
        
        public func toJSON() -> JSON? {
            var model = JSON()
            model["user_id"] = userId
            model["action"] = action.rawValue
            model["channel"] = channel
            
            if let memberId = memberId {
                model["member_id"] = memberId
            }
            
            return jsonify([model])
        }
    }
}
