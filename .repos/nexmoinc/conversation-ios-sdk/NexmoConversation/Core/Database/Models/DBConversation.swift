//
//  DBConversation.swift
//  NexmoConversation
//
//  Created by James Green on 26/08/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import GRDB

internal class DBConversation: Record {
    /* Data fields / columns. */
    internal var rest: ConversationModel // Just use the REST definition directly because no point in duplicating all the fields twice.
    
    internal var requiresSync: Bool
    internal var dataIncomplete: Bool
    internal var mostRecentEventIndex: Int32?
    internal var lastUpdated: Date
    
    // MARK:
    // MARK: Initializers

    internal init(conversation: ConversationModel) {
        rest = conversation
        requiresSync = true
        dataIncomplete = false
        lastUpdated = Date()
        
        super.init()
    }
    
    /* GRDB */
    required init(row: Row) {
        let created: Date = row.value(named: "timestampCreated")

        var state: MemberModel.State? {
            guard let state = row.value(named: "state") as? Int64 else { return nil }

            return MemberModel.State.from(Int32(state))
        }

        rest = ConversationModel(
            uuid: row.value(named: "uuid"),
            name: row.value(named: "name"),
            sequenceNumber: row.value(named: "sequenceNumber"),
            members: [],
            created: created,
            displayName: row.value(named: "displayName"),
            state: state,
            memberId: row.value(named: "memberId")
        )
        
        /* Our members. */
        requiresSync = row.value(named: "requiresSync")
        dataIncomplete = row.value(named: "dataIncomplete")
        mostRecentEventIndex = row.value(named: "mostRecentEventIndex")
        lastUpdated = row.value(named: "lastUpdated")
        
        super.init(row: row)
    }
    
    // MARK:
    // MARK: Name
    
    override class var databaseTableName: String {
        return "conversations"
    }
    
    // MARK:
    // MARK: Mapping

    override var persistentDictionary: [String : DatabaseValueConvertible?] {
        return ["uuid": rest.uuid,
                "name": rest.name,
                "sequenceNumber": rest.sequenceNumber,
                "timestampCreated": rest.created,
                "displayName": rest.displayName,
                "requiresSync": requiresSync,
                "dataIncomplete": dataIncomplete,
                "mostRecentEventIndex": mostRecentEventIndex,
                "lastUpdated": lastUpdated
        ]
    }
}
