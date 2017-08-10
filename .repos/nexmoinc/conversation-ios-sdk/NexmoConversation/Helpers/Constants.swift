//
//  Constants.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 28/10/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation

/// NexmoConversation constants
internal struct Constants {
    
    // MARK:
    // MARK: Keys
    
    /// Constants keys
    internal struct Keys {
        
        /// Main bundle key for SDK
        internal static let nexmoDictionary = "Nexmo"
        
        /// API Key
        internal static let applicationID = "ConversationApplicationID"
    }
    
    // MARK:
    // MARK: SDK
    
    /// SDK define list
    internal struct SDK {
        
        /// Bundle version
        internal static let version: String = {
            // CFBundleShortVersionString does not have a constant
            guard let version = Bundle(for: ConversationClient.self).infoDictionary?["CFBundleShortVersionString"] as? String else {
                // fatal error ok since it's controllable in dev mode
                fatalError("SDK failed to get version number")
            }
            
            return version
        }()
        
        /// Bundle name
        internal static let name: String = {
            // fatal error are only caused by developer mis-configurations
            guard let version = Bundle(for: ConversationClient.self).infoDictionary?[kCFBundleNameKey as String] as? String else {
                fatalError("SDK failed to get own name")
            }
            
            return version
        }()
    }
}
