//
//  Decoder+Helper.swift
//  NexmoConversation
//
//  Created by Jodi Humphreys on 11/23/16.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Gloss

internal extension Decoder {
    
    // MARK:
    // MARK: Decoder
    
    /**
     Decodes JSON to an array of [String:Date].
     
     - parameter key:           Key used in JSON for decoded value.
     - parameter dateFormatter: Date formatter used to create date.
     
     - returns: Value decoded from JSON.
     */
    internal static func decode(dateDictionaryForKey key: String, dateFormatter: DateFormatter, keyPathDelimiter: String = GlossKeyPathDelimiter) -> (JSON) -> [String:Date]? {
        return { json in
            guard let strings = json.valueForKeyPath(keyPath: key, withDelimiter: keyPathDelimiter) as? [String : String] else { return nil }
            
            return strings.reduce([String: Date]()) { result, value in
                guard let date = dateFormatter.date(from: value.value) else { return result }
                
                var result = result
                result[value.key] = date
                
                return result
            }
        }
    }
}
