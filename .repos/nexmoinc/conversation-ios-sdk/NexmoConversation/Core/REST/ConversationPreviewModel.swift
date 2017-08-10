//
//  ConversationPreviewModel.swift
//  NexmoConversation
//
//  Created by James Green on 26/08/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Gloss

/// Conversation preview model show a small preview of a conversation
@objc(NXMConversationPreviewModel)
public class ConversationPreviewModel: NSObject, Decodable {
    
    // MARK:
    // MARK: Properties
    
    /// Id
    public let uuid: String
    
    /// name
    public let name: String
    
    /// Sequence number
    public let sequenceNumber: Int

    /// Member Id
    public let memberId: String

    /// Member state
    public let state: MemberModel.State

    // MARK:
    // MARK: Initializers

    internal init(_ conversation: ConversationModel, for member: MemberModel) {
        uuid = conversation.uuid
        name = conversation.name
        sequenceNumber = conversation.sequenceNumber
        memberId = member.id
        state = member.state
    }

    public required init?(json: JSON) {
        // TOOD: review ones CS remodelling complete [Aug 17]
        if let uuid: String = "id" <~~ json {
           self.uuid = uuid
        } else if let uuid: String = "uuid" <~~ json {
            self.uuid = uuid
        } else if let uuid: String = "cid" <~~ json {
            self.uuid = uuid
        } else if let uuid: String = "cname" <~~ json {
            self.uuid = uuid
        } else {
            return nil
        }

        guard let name: String = "name" <~~ json else { return nil }
        
        self.name = name

        if let sequenceNumber: Int = "sequence_number" <~~ json {
            self.sequenceNumber = sequenceNumber
        } else {
            self.sequenceNumber = 0
        }

        // Not sure some json response return cap and non-caps for member_Id
        guard let state: String = "state" <~~ json,
            let memberState = MemberModel.State(rawValue: state.lowercased()),
            let id: String = ("member_Id" <~~ json) ?? ("member_id" <~~ json) else {
            return nil
        }

        self.memberId = id
        self.state = memberState
    }
}

/// compare conversation lite model
public func ==(lhs: ConversationPreviewModel, rhs: ConversationPreviewModel) -> Bool {
    return lhs.uuid == rhs.uuid
}
