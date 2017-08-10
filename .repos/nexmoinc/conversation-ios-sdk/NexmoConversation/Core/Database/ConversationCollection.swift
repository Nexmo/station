//
//  ConversationCollection.swift
//  NexmoConversation
//
//  Created by shams ahmed on 29/03/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import RxSwift

/// Collection of conversations
public class ConversationCollection: NexmoConversation.LazyCollection<Conversation> {

    public typealias T = Change<Conversation, Reason>

    // MARK:
    // MARK: Enum

    /// Reason of change in a collection
    ///
    /// - new: new conversation from sync
    /// - invitedBy: new conversation received from a member invite
    public enum Reason {
        case new
        case invitedBy(Member)
    }

    /// Database manager
    internal weak var cache: CacheManager? {
        didSet {
            // Once the cache been set preload all uuids and conversations
            refetch()

            setup()
        }
    }

    /// Update subject value
    internal var value: T {
        get {
            return subject.value
        }
        set {
            subject.value = newValue

            self.refetch()
        }
    }
    
    // MARK:
    // MARK: Properties - Observable
    
    /// Notification
    private let subject = Variable<T>(.inserted([], .new))
    
    /// Observe for changes to collection
    public lazy var asObservable: Observable<T> = {
        return self.subject.asObservable().skip(1).observeOnMainThread()
    }()
    
    // MARK:
    // MARK: Initializers
    
    /// Construct a collection of all (complete) conversations, sorted by date of most recent activity.
    internal init(cache: CacheManager?) {
        super.init()

        if let cache = cache {
            self.cache = cache

            setup()
        }
    }

    // MARK:
    // MARK: Setup

    private func setup() {
        let newUuids = cache?.database.conversation.dataIncompleteUuids
        let conversations = newUuids?.flatMap { self[$0] }

        if let conversations = conversations, !conversations.isEmpty {
            subject.value = .inserted(conversations, .new)
        }
    }

    // MARK:
    // MARK: Collection

    internal func refetch() {
        guard let cache = cache else { return }
        
        uuids = cache.database.conversation.dataIncompleteUuids
    }

    // MARK:
    // MARK: Subscript
    
    /// Get conversation with uuid
    ///
    /// - Parameter uuid: conversation uuid
    public override subscript(_ uuid: String) -> Conversation? {
        return cache?.conversationCache.get(uuid: uuid)
    }
    
    /// Get conversation from position i
    ///
    /// - Parameter i: index
    public override subscript(_ i: Int) -> Conversation {
        guard let cache = cache else { fatalError("Cache not been set yet") }
        guard uuids.count >= i, let conversation = cache.conversationCache.get(uuid: uuids[i]) else {
            fatalError("Collection out of bound")
        }
        
        return conversation
    }
}
