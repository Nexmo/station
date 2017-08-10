//
//  Dictionary+Helper.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 08/02/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation

extension Dictionary {

    // MARK:
    // MARK: JSON String
    
    /// Turn dictionary to JSON string
    var JSONString: String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self) else { return nil }
        
        let JSONString = String(data: data, encoding: .utf8)
            
        return JSONString
    }
}
