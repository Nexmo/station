//
//  Body+Text.swift
//  NexmoConversation
//
//  Created by shams ahmed on 22/06/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Gloss

/// Body models
internal extension Event.Body {
    
    // MARK:
    // MARK: Text
    
    /// Text model
    internal struct Text: Decodable {
        
        /// Text
        internal let text: String
        
        // MARK:
        // MARK: Initializers

        internal init?(json: JSON) {
            guard let text: String = "text" <~~ json else { return nil }
            
            self.text = text
        }
    }
    
    // MARK:
    // MARK: Image
    
    /// Image model - To be implemented
    internal struct Image: Decodable {
        
        // MARK:
        // MARK: Initializers

        // Unimplemented method
        internal init?(json: JSON) {
            // Unimplemented method
            return nil
        }
    }
    
    // MARK:
    // MARK: Delete
    
    /// Delete model
    internal struct Delete: Decodable {

        /// Event Id
        let event: String
        
        // MARK:
        // MARK: Initializers
        
        internal init?(json: JSON) {
            guard let id: String = "event_id" <~~ json else { return nil }
            
            event = id
        }
    }

    // MARK:
    // MARK: Member Invite

    /// Member invite model
    internal struct MemberInvite: Decodable {

        // MARK:
        // MARK: User

        /// Member invite user model
        internal struct User: Decodable {

            /// Member Id
            internal let memberId: String

            /// User Id
            internal let userId: String

            /// Username/Email
            internal let username: String

            // MARK:
            // MARK: Initializers

            internal init?(json: JSON) {
                guard let memberId: String = "user.member_id" <~~ json else { return nil }
                guard let userId: String = "user.user_id" <~~ json else { return nil }
                guard let username: String = "user.name" <~~ json else { return nil }

                self.memberId = memberId
                self.userId = userId
                self.username = username
            }
        }

        /// Conversation Name
        internal let conversationName: String

        /// Invited by email
        internal let invitedBy: String

        /// Date
        internal let timestamp: Date

        /// User
        internal let user: User

        // MARK:
        // MARK: Initializers

        internal init?(json: JSON) {
            guard let conversationName: String = "cname" <~~ json else { return nil }
            guard let invitedBy: String = "invited_by" <~~ json else { return nil }
            guard let formatter = DateFormatter.ISO8601,
                let timestamp = Decoder.decode(dateForKey: "timestamp.invited", dateFormatter: formatter)(json) else {
                return nil
            }
            guard let user = User(json: json) else { return nil }

            self.conversationName = conversationName
            self.invitedBy = invitedBy
            self.timestamp = timestamp
            self.user = user
        }
    }
}
