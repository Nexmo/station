//
//  LazyCollection.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 30/03/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/*
 The idea of this collection helper is to snapshot a list in time by (cheaply) gathering
 a list of uuids when constructed; and then lazily get the full records on demand. The
 idea is that the list doesn't then change and can be used in things list UITableViews
 where it is important it doesn't change under the feet of the app. If the app wants to
 get the latest list it can simply fetch a fresh instance of the collection.
 */
public class LazyCollection<T>: Collection {
    
    // MARK:
    // MARK: Properties
    
    internal var mutex = NSConditionLock()
    internal var uuids: [String] = []
    
    /// Start index
    public var startIndex: Int { return 0 }
    
    /// End index
    public var endIndex: Int { return uuids.count }
    
    // MARK:
    // MARK: Subscript
    
    /// Get T from position i
    ///
    /// - Parameter i: index
    public subscript(i: Int) -> T {
        preconditionFailure("This method must be overridden")
    }
    
    /// Get T at index otherwise return nil
    ///
    /// - Parameter index: index
    public subscript (safe index: Int) -> T? {
        return index < count ? self[index] : nil
    }
    
    /// Get T from uuid
    ///
    /// - Parameter uuid: uuid of T
    public subscript(uuid: String) -> T? {
        preconditionFailure("This method must be overridden")
    }
    
    // MARK:
    // MARK: Index
    
    /// Index after position i
    public func index(after i: Int) -> Int {
        guard i != endIndex else { fatalError("Cannot increment beyond endIndex") }
        
        return i + 1
    }
}
