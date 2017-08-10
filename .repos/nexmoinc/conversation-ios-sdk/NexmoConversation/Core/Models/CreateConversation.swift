//
//  CreateConversation.swift
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

    /// Create a conversation request model
    public struct CreateConversation: Encodable {

        // MARK:
        // MARK: Properties

        /// Display name for conversation
        public let displayName: String

        // MARK:
        // MARK: Initializers

        public init(name displayName: String) {
            self.displayName = displayName
        }

        // MARK:
        // MARK: JSON

        public func toJSON() -> JSON? {
            let model = ["display_name": displayName]
            
            return jsonify([model])
        }
    }
}
