//
//  MemberStatus.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 06/12/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Gloss

/// Model for response of join/invite member request
internal struct MemberStatus: Decodable {
    
    /// member id
    internal let memberId: String
    
    /// user id
    internal let userId: String
    
    /// member state
    internal let state: MemberModel.State
    
    /// timeStamp
    internal let timeStamp: Date
    
    /// member channel type
    internal let channel: [MemberModel.Channel: [String: String]]
    
    // MARK:
    // MARK: Int
    
    internal init?(json: JSON) {
        guard let stateString: String = "state" <~~ json else { return nil }
        
        guard let memberId: String = "id" <~~ json,
            let userId: String = "user_id" <~~ json,
            let state = MemberModel.State(rawValue: stateString.lowercased()) else { return nil }
        
        guard let formatter = DateFormatter.ISO8601,
            let timestamp = Decoder.decode(dateForKey: "timestamp.\(state.rawValue)", dateFormatter: formatter)(json) else {
            return nil
        }
        
        if let channel: [String: [String: String]] = "channel" <~~ json,
            let firstKey = channel.first?.key,
            let key = MemberModel.Channel(rawValue: firstKey),
            let value = channel.first?.value {
            self.channel = [key: value]
        } else {
            self.channel = [:]
        }
        
        self.memberId = memberId
        self.userId = userId
        self.state = state
        self.timeStamp = timestamp
    }
}
