//
//  MembershipEvent.swift
//  NexmoConversation
//
//  Created by James Green on 13/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Gloss

/// Membership Event
@objc(NXMMembershipEvent)
public class MembershipEvent: EventBase { }

/// Invite Membership Event
@objc(NXMMemberInvitedEvent)
public class MemberInvitedEvent: MembershipEvent {
    
    // MARK:
    // MARK: Properties
    
    /// Invited date
    public internal(set) lazy var invitedDate: Date? = {
        guard let formatter = DateFormatter.ISO8601,
            let date = Decoder.decode(dateForKey: "timestamp.invited", dateFormatter: formatter)(self.data.body) else {
            return nil
        }
        
        return date
    }()
    
    /// Member who been invited to conversation
    public internal(set) lazy var invitedMember: Member? = {
        guard let json = self.data.body["user"] as? JSON, let member = MemberModel(json: json, state: .invited) else { return nil }
        
        return Member(conversationUuid: self.uuid, member: member)
    }()
    
    /// invited by user
    public internal(set) lazy var invitedBy: String? = { return self.data.body["invited_by"] as? String }()
}

/// Join Membership Event
@objc(NXMMemberJoinedEvent)
public class MemberJoinedEvent: MembershipEvent {

    // MARK:
    // MARK: Properties
    
    /// Join date
    public internal(set) lazy var joinedDate: Date? = {
        guard let formatter = DateFormatter.ISO8601,
            let date = Decoder.decode(dateForKey: "timestamp.joined", dateFormatter: formatter)(self.data.body) else {
            return nil
        }
        
        return date
    }()
}

/// Left Membership Event
@objc(NXMMemberLeftEvent)
public class MemberLeftEvent: MembershipEvent {
    
    // MARK:
    // MARK: Properties
    
    /// Lefted date
    public internal(set) lazy var leftDate: Date? = {
        guard let formatter = DateFormatter.ISO8601,
            let date = Decoder.decode(dateForKey: "timestamp.left", dateFormatter: formatter)(self.data.body) else {
            return nil
        }
        
        return date
    }()
}
