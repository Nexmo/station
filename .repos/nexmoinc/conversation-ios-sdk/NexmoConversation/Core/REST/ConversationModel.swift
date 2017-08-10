//
//  ConversationModel.swift
//  NexmoConversation
//
//  Created by James Green on 30/08/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Gloss

/// Conversation model
@objc(NXMConversationModel)
public class ConversationModel: NSObject, Decodable {
    
    // MARK:
    // MARK: Properties

    /// Id
    public let uuid: String

    /// Name
    public let name: String

    /// Sequence number
    public let sequenceNumber: Int

    /// List of members
    public internal(set) var members: [MemberModel] = []
    
    /// Date of conversation been created
    public internal(set) var created: Date
    
    /// Display name
    public internal(set) var displayName: String
    
    // MARK:
    // MARK: Initializers

    internal init(uuid: String, name: String="", sequenceNumber: Int=0, members: [MemberModel]=[], created: Date, displayName: String="", state: MemberModel.State?, memberId: String?) {
        self.uuid = uuid
        self.name = name
        self.sequenceNumber = sequenceNumber
        self.members.append(contentsOf: members)
        self.created = created
        self.displayName = displayName
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
        
        guard let members: [MemberModel] = "members" <~~ json else { return nil }
        
        self.members = members
        
        guard let formatter = DateFormatter.ISO8601,
            let date = Decoder.decode(dateForKey: "timestamp.created", dateFormatter: formatter)(json) else {
            return nil
        }
        
        created = date
        displayName = ("display_name" <~~ json) ?? ""
    }
}

/// Compare conversation model
public func ==(lhs: ConversationModel, rhs: ConversationModel) -> Bool {
    return lhs.uuid == rhs.uuid
}
