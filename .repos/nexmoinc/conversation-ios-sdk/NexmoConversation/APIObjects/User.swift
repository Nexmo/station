//
//  User.swift
//  NexmoConversation
//
//  Created by James Green on 01/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation

/// User Facade Object
@objc(NXMUser)
public class User: NSObject {

    // MARK:
    // MARK: Properties
    
    internal var data: DBUser
    
    /// User uuid
    public var uuid: String { return data.rest.uuid }
    
    /// Is this user the person using this app
    public var isMe: Bool {
        guard case .loggedIn(let session) = ConversationClient.instance.account.state.value,
            data.rest.uuid == session.userId else {
            // TODO: refactor to remove calling ConversationClient.instance
            return false
        }
        
        return true
    }
    
    /// User's username
    public var name: String { return data.rest.name }
    
    /// User's display name
    public var displayName: String { return data.rest.displayName }

    // MARK:
    // MARK: NSObject
    
    /// Description
    public override var description: String { return "User(userId=" + data.rest.uuid + ")" }
    
    /// Hashable
    public override var hashValue: Int { return data.rest.uuid.hashValue }
    
    // MARK:
    // MARK: Initializers

    internal init(data: DBUser) {
        self.data = data
        
        super.init()
    }
    
    // MARK:
    // MARK: Update

    internal func updateWithNewData(new: DBUser) -> (/* Updates made */Bool, /* events */ SignalInvocations) {
        var updatesMade = false
        let events: SignalInvocations = SignalInvocations()
        
        SignalInvocations.compareField(current: &self.data.rest.displayName, new: new.rest.displayName, updatesMade: &updatesMade, signals: events, signal: { _, _ in })
        SignalInvocations.compareField(current: &self.data.rest.imageUrl, new: new.rest.imageUrl, updatesMade: &updatesMade, signals: events, signal: { _, _ in })
        SignalInvocations.compareField(current: &self.data.rest.name, new: new.rest.name, updatesMade: &updatesMade, signals: events, signal: { _, _ in })

        return (updatesMade, events)
    }
    
    // MARK:
    // MARK: Override
    
    public override func isEqual(_ object: Any?) -> Bool {
        guard let user = object as? User else { return false }
        
        return self.uuid == user.uuid
    }
}

// MARK:
// MARK: Compare

/// Compare wherever a user is the same
///
/// - Parameters:
///   - lhs: user
///   - rhs: user
/// - Returns: result
public func ==(lhs: User, rhs: User) -> Bool {
    return (lhs.data.rest.uuid == rhs.data.rest.uuid)
}
