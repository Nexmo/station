//
//  Member.swift
//  NexmoConversation
//
//  Created by James Green on 30/08/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import RxSwift

/// Member Facade Object
@objc(NXMMember)
public class Member: NSObject {

    // MARK:
    // MARK: Properties
    
    internal var data: DBMember
    
    /// The member uuid
    public var uuid: String { return data.rest.id }
    
    /// The user corresponding to this member.  Contains user name for this member.
    public var user: User { return ConversationClient.instance.objectCache.userCache.get(uuid: data.rest.userId)! }
    
    /// The state of this member
    public var state: MemberModel.State { return data.rest.state }
    
    /// The conversation this member belongs to
    public var conversation: Conversation { return ConversationClient.instance.objectCache.conversationCache.get(uuid: data.parent)! }

    /// The member who invited you
    public var invitedBy: Member? {
        return ConversationClient.instance.objectCache.memberCache
            .all()
            .flatMap { $0 }
            .first(where: { $0.data.rest.name == self.data.rest.invitedBy })
    }
    
    /// Rx
    internal let disposeBag = DisposeBag()
    
    // MARK:
    // MARK: Properties - Observable

    /// Signal for when the member starts or stops typing.
    public let typing = Variable<Bool>(false)
    
    // MARK:
    // MARK: NSObject
    
    /// Hashable
    public override var hashValue: Int { return data.rest.id.hashValue }
    
    /// Description
    public override var description: String { return "\(data.rest.id) \(data.rest.name) \(data.rest.userId) \(data.parent) \(state)" }
    
    // MARK:
    // MARK: Initializers

    internal init(data: DBMember) {
        self.data = data
        
        super.init()
    }
    
    internal init(conversationUuid: String, member: MemberModel) {
        self.data = DBMember(conversationUuid: conversationUuid, member: member)
        
        super.init()
    }
    
    // MARK:
    // MARK: Date
    
    /// Date that a member's state changed
    ///
    /// - parameter state: Member.State
    ///
    /// - returns: date of reaching this member state
    public func date(of state: MemberModel.State) -> Date? {
        return data.rest.date(of: state)
    }
    
    // MARK:
    // MARK: Update

    internal func updateWithNewData(new: DBMember, isMe: Bool) -> (/* Updates made */Bool, /* events */ SignalInvocations) {
        var updatesMade = false
        let events: SignalInvocations = SignalInvocations()
        
        /* Look for updates. */
        SignalInvocations.compareField(current: &self.data.rest.state, new: new.rest.state, updatesMade: &updatesMade, signals: events, signal: { (_, new) in
            if new == MemberModel.State.joined {
                self.conversation.memberJoined.emit(self)
            } else if new == MemberModel.State.left {
                self.conversation.memberLeft.emit(self)
            } else if new == MemberModel.State.invited {
                self.conversation.memberInvited.emit(self) // This is unlikely (never) to be triggered here - more likely in the sync manager when a new member is discovered.
            }
        })
        
        return (updatesMade, events)
    }
    
    // MARK:
    // MARK: Kick
    
    /// Kick member out of this conversation
    ///
    /// - returns: result of operation
    public func kick() -> Single<Void> {
        return conversation.membershipController.kick(uuid, in: conversation.uuid)
            .observeOnMainThread()
            .map { _ in () }
            .asSingle()
    }
}

// MARK:
// MARK: Compare

/// Compare wherever member is the same
///
/// - Parameters:
///   - lhs: member
///   - rhs: member
/// - Returns: result
public func ==(lhs: Member, rhs: Member) -> Bool {
    return lhs.data.rest.id == rhs.data.rest.id
}

/// Compare member state and event type
///
/// - Parameters:
///   - lhs: member model state
///   - rhs: event type
/// - Returns: result
public func ==(lhs: MemberModel.State, rhs: Event.EventType) -> Bool {
    switch (lhs, rhs) {
    case (.joined, .memberJoined): return true
    case (.invited, .memberInvited): return true
    case (.left, .memberLeft): return true
    default: return false
    }
}
