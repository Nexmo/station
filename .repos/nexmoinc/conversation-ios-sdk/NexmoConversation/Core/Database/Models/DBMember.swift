//
//  DBMember.swift
//  NexmoConversation
//
//  Created by James Green on 30/08/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import GRDB

/// Member DB model
internal class DBMember: Record {
    
    /// Conversation uuid
    internal var parent: String
    
    /// Rest
    internal var rest: MemberModel // Just use the REST definition directly because no point in duplicating all the fields twice.
    
    // MARK:
    // MARK: Initializers
    
    internal init(conversationUuid: String, member: MemberModel) {
        rest = member
        parent = conversationUuid
        
        super.init()
    }
    
    internal required init(row: Row) {
        parent = row.value(named: "parent")
        
        let memberId: String = row.value(named: "memberId")
        let name: String = row.value(named: "name")
        let stateInt: Int32 = row.value(named: "state")
        let state = MemberModel.State.from(stateInt)!
        let userId: String = row.value(named: "userId")
        let invitedBy: String? = row.value(named: "invitedBy")
        let timestamp: [MemberModel.State: Date?] = [
            MemberModel.State.joined: row.value(named: "joinedTimestamp"),
            MemberModel.State.invited: row.value(named: "invitedTimestamp"),
            MemberModel.State.left: row.value(named: "leftTimestamp")
        ]

        rest = MemberModel(memberId, name: name, state: state, userId: userId, invitedBy: invitedBy, timestamp: timestamp)
        
        super.init(row: row)
    }
    
    // MARK:
    // MARK: Database
    
    override internal class var databaseTableName: String {
        return "members"
    }
    
    override internal var persistentDictionary: [String : DatabaseValueConvertible?] {
        return ["parent": parent,
                "memberId": rest.id,
                "name": rest.name,
                "state": rest.state.intValue,
                "userId": rest.userId,
                "invitedBy": rest.invitedBy,
                "joinedTimestamp": rest.date(of: .joined),
                "invitedTimestamp": rest.date(of: .invited),
                "leftTimestamp": rest.date(of: .left)
            ]
    }
}
