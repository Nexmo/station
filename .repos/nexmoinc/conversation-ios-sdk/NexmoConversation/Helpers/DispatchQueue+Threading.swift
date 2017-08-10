//
//  DispatchQueue+Threading.swift
//  NexmoConversation
//
//  Created by shams ahmed on 29/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation

// MARK: - Dispatch queue helper for comman queues
internal extension DispatchQueue {
    
    // MARK:
    // MARK: Parsering
    
    /// Queue used to process Data to JSON models
    internal static var parsering: DispatchQueue {
        let bundle = Bundle(for: ConversationClient.self)
        
        guard let name = bundle.infoDictionary?[kCFBundleIdentifierKey as String] as? String,
            !name.isEmpty,
            !Environment.inFatalErrorTesting else { fatalError() } // fine for testing purposes
        
        return DispatchQueue(label: "\(name).parsering", qos: .background)
    }
}
