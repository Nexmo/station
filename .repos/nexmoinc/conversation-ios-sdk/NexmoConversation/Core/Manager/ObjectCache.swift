//
//  ObjectCache.swift
//  NexmoConversation
//
//  Created by James Green on 30/08/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation

internal class ObjectCache<T: AnyObject> {
    
    typealias ObjectGenerator = (/* uuid */ String) -> T?
    
    private var cache: [String: ObjectCacheItemWrapper<T>] = Dictionary()
    private var cacheLock = NSConditionLock()
    private var generator: ObjectGenerator?
    
    // MARK:
    // MARK: Setter
    
    internal func setGenerator(_ generator: @escaping ObjectGenerator) {
        self.generator = generator
    }
    
    // MARK:
    // MARK: Getter
    
    internal func get(uuid: String) -> T? {
        /* Mutex. */
        cacheLock.lock()
        defer { cacheLock.unlock() }

        // TODO Consider looking through all values and garbage collecting as appropriate. Maybe make
        // this an option in the constructor because it is probably wasteful for small sets of objects
        // but for things like events might be quite important. Probably don't want to do it every
        // time so the constructor could take an integer which say do a garbage collect 1 in X times.
        
        /* See if we can find a suitable object already in the cache? */
        if let cachedItemWrapper = cache[uuid] {
            /* Got one, check it's not been garbage collected. */
            
            if let cachedItem = cachedItemWrapper.item {
                /* return the cached item. */
                return cachedItem
            } else {
                /* It has been garbage collected, so remove it from the cache and drop through to the code that generates a new item afresh. */
                cache.removeValue(forKey: uuid)
            }
        }
        
        guard let item = generator?(uuid) else { return nil }
        
        cache[uuid] = ObjectCacheItemWrapper<T>(item: item)
        
        return item
    }
    
    internal func all() -> [T?] {
        return cache.values.map { $0.item.value }.makeIterator().map { $0 }
    }
    
    // MARK:
    // MARK: Clear
    
    internal func clear(uuid: String) {
        /* Mutex. */
        cacheLock.lock()
        defer { cacheLock.unlock() }
        
        cache.removeValue(forKey: uuid)
    }
    
    internal func clear() {
        /* Mutex. */
        cacheLock.lock()
        defer { cacheLock.unlock() }
       
        cache.removeAll()
    }
}

internal class ObjectCacheItemWrapper<T: AnyObject> {
    internal weak var item: T?
    
    internal init(item: T) {
        self.item = item
    }
}
