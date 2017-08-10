//
//  MemberCollection.swift
//  NexmoConversation
//
//  Created by shams ahmed on 29/03/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/// Cache of all members for a conversation
public class MemberCollection: NexmoConversation.LazyCollection<Member> {
    
    private let databaseManager: DatabaseManager?

    private let conversationUuid: String

    /// list of all users
    public var allUsers: [User] {
        defer { mutex.unlock() }

        mutex.lock()

        if userMembershipLookup.isEmpty {
            populateLookup()
        }

        return userMembershipLookup.map { $0.key }
    }

    /// membership of a given user
    private var userMembershipLookup = [User: [Member]]()

    // MARK:
    // MARK: Initializers
    
    /// Construct a collection of all members in the given conversation
    internal init(conversationUuid: String, databaseManager: DatabaseManager) {
        self.databaseManager = databaseManager
        self.conversationUuid = conversationUuid

        super.init()
        
        setup()
    }
    
    /// Constrict a collection of all member to whom an event was distributed
    internal init(event: TextEvent) {
        databaseManager = nil
        conversationUuid = event.conversation.uuid

        super.init()
        
        setup(event)
    }
    
    // MARK:
    // MARK: Setup
    
    private func setup() {
        refresh()
    }
    
    private func setup(_ event: TextEvent) {
        uuids = event.data.distribution
    }

    // MARK:
    // MARK: Refresh

    /// Refresh collection when ever there a change to a conversation
    internal func refresh() {
        if let memberIds = databaseManager?.member[parent: conversationUuid].map({ member in member.rest.id }) {
            uuids = memberIds
        }
    }

    // MARK:
    // MARK: Cache

    private func populateLookup() {
        /* Produce a dictionary of membership lists indexed by user. */
        for member in (self as NexmoConversation.LazyCollection<Member>) {
            var membership = userMembershipLookup[member.user] ?? []
            
            membership.append(member)
            userMembershipLookup[member.user] = membership
        }
    }
    
    // MARK:
    // MARK: Helper

    /// Fetch all members for user
    public func membershipForUser(user: User) -> [Member] {
        /* Mutex. */
        mutex.lock()
        defer { mutex.unlock() }
        
        if userMembershipLookup.isEmpty {
            populateLookup()
        }
        
        guard let result = userMembershipLookup[user] else {
            // rare crashes when using subscript where the user equal (==) does not match a user. could be swift 3 issue but can't find a specfic ticket on swift bug list
            return userMembershipLookup.first(where: { $0.key == user })?.value ?? []
        }
        
        return result
    }

    // MARK:
    // MARK: Subscript

    /// Get member by Member Id
    ///
    /// - Parameter uuid: Member iD
    public override subscript(uuid: String) -> Member? {
        return ConversationClient.instance.objectCache.memberCache.get(uuid: uuid)
    }

    /// Get member from position i
    ///
    /// - Parameter i: i
    public override subscript(i: Int) -> Member {
        return ConversationClient.instance.objectCache.memberCache.get(uuid: uuids[i])!
    }
}
