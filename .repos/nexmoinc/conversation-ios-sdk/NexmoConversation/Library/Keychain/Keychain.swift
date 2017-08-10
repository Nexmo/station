//
//  Keychain.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 24/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

/// Keychain manager
internal class Keychain {
    
    internal enum Keys: String {
        case username
        case password
        case token
    }
    
    // MARK:
    // MARK: Setter
    
    @discardableResult
    internal func set(_ value: String, forKey key: Keys) -> Bool {
        // For unit testing, let save to user default
        guard !Environment.inTesting else {
            UserDefaults.standard.setValue(value, forKey: key.rawValue)
            UserDefaults.standard.synchronize()
            
            return true
        }
        
        guard valueData(forKey: key) == nil else { return update(value, forKey: key) }
        
        return create(value, forKey: key)
    }
    
    // MARK:
    // MARK: Getter
    
    internal func value(forKey key: Keys) -> String? {
        // For unit testing, let fatch to user default
        guard !Environment.inTesting else { return UserDefaults.standard.string(forKey: key.rawValue) }
        
        guard let valueData = valueData(forKey: key) else { return nil }
        
        return NSString(data: valueData, encoding: String.Encoding.utf8.rawValue) as String?
    }
    
    internal func allValues() -> [[String: String]]? {
        var searchDictionary = basicDictionary()
        
        searchDictionary[kSecMatchLimit as String] = kSecMatchLimitAll
        searchDictionary[kSecReturnAttributes as String] = kCFBooleanTrue
        searchDictionary[kSecReturnData as String] = kCFBooleanTrue
        
        var retrievedAttributes: AnyObject?
        var retrievedData: AnyObject?
        
        var status = SecItemCopyMatching(searchDictionary as CFDictionary, &retrievedAttributes)
        
        if status != errSecSuccess {
            return nil
        }
        
        status = SecItemCopyMatching(searchDictionary as CFDictionary, &retrievedData)
        
        if status != errSecSuccess {
            return nil
        }
        
        guard let attributeDicts = retrievedAttributes as? [[String: AnyObject]] else { return nil }
        
        var allValues = [[String: String]]()
        
        for attributeDict in attributeDicts {
            guard let keyData = attributeDict[kSecAttrAccount as String] as? Data else { continue }
            guard let valueData = attributeDict[kSecValueData as String] as? Data else { continue }
            guard let key = NSString(data: keyData, encoding: String.Encoding.utf8.rawValue) as String? else { continue }
            guard let value = NSString(data: valueData, encoding: String.Encoding.utf8.rawValue) as String? else { continue }
            
            allValues.append([key: value])
        }
        
        return allValues
    }
    
    // MARK:
    // MARK: Remove

    @discardableResult
    internal func remove(forKey key: Keys) -> Bool {
        // For unit testing, let fatch to user default
        guard !Environment.inTesting else {
            UserDefaults.standard.removeObject(forKey: key.rawValue)
            UserDefaults.standard.synchronize()
            
            return true
        }
        
        let searchDictionary = newSearchDictionary(forKey: key)
        
        return SecItemDelete(searchDictionary as CFDictionary) == errSecSuccess
    }
    
    // MARK:
    // MARK: Reset
    
    @discardableResult
    internal func reset() -> Bool {
        let searchDictionary = basicDictionary()

        return SecItemDelete(searchDictionary as CFDictionary) == errSecSuccess
    }
    
    // MARK:
    // MARK: Subscript
    
    subscript(key: Keys) -> String? {
        get {
            return self.value(forKey: key)
        }
        set {
            if let newValue = newValue {
                self.set(newValue, forKey: key)
            }
        }
    }
}

fileprivate extension Keychain {
    
    // MARK:
    // MARK: Setter
    
    func create(_ value: String, forKey key: Keys) -> Bool {
        var dictionary = newSearchDictionary(forKey: key)
        dictionary[kSecValueData as String] = value.data(using: .utf8, allowLossyConversion: false) as AnyObject?
        
        let result = SecItemAdd(dictionary as CFDictionary, nil)
        
        return result == errSecSuccess
    }
    
    func update(_ value: String, forKey key: Keys) -> Bool {
        let searchDictionary = newSearchDictionary(forKey: key)
        var updateDictionary = [String: AnyObject]()
        
        updateDictionary[kSecValueData as String] = value.data(using: .utf8, allowLossyConversion: false) as AnyObject?
        
        return SecItemUpdate(searchDictionary as CFDictionary, updateDictionary as CFDictionary) == errSecSuccess
    }
    
    // MARK:
    // MARK: Getter
    
    func valueData(forKey key: Keys) -> Data? {
        var searchDictionary = newSearchDictionary(forKey: key)
        var retrievedData: AnyObject?
        
        searchDictionary[kSecMatchLimit as String] = kSecMatchLimitOne
        searchDictionary[kSecReturnData as String] = kCFBooleanTrue
        
        guard SecItemCopyMatching(searchDictionary as CFDictionary, &retrievedData) == errSecSuccess else { return nil }
        
        return retrievedData as? Data
    }
    
    func newSearchDictionary(forKey key: Keys) -> [String: AnyObject] {
        let encodedIdentifier = key.rawValue.data(using: .utf8, allowLossyConversion: false)
        var searchDictionary = basicDictionary()
        
        searchDictionary[kSecAttrGeneric as String] = encodedIdentifier as AnyObject?
        searchDictionary[kSecAttrAccount as String] = encodedIdentifier as AnyObject?
        
        return searchDictionary
    }
    
    func basicDictionary() -> [String: AnyObject] {
        let serviceName = Bundle(for: ConversationClient.self).infoDictionary?[kCFBundleIdentifierKey as String] as? String ?? "com.nexmo.conversationSDK"
        
        return [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName as AnyObject
        ]
    }
}
