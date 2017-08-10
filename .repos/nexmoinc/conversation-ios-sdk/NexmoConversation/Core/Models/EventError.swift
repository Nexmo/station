//
//  EventError.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 04/04/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Gloss

/// Extension for error responses
internal extension Event {
    
    /// Capi event errors
    ///
    /// - eventNotFound: event not found on capi
    /// - unknown: other error not hard-coded in SDK
    internal enum Errors: String, Error {
        case eventNotFound = "event:error:not-found"
        case unknown
        
        // MARK:
        // MARK: Builder

        /// Build error
        ///
        /// - Parameter raw: raw json response
        /// - Returns: Error
        internal static func build(_ raw: Data?) -> Errors {
            guard let rawData = raw,
                let object = try? JSONSerialization.jsonObject(with: rawData),
                let json = object as? JSON,
                let code: String = "code" <~~ json,
                let error = Errors(rawValue: code) else { return Errors.unknown }
            
            return error
        }
    }
}

// MARK:
// MARK: Equatable

internal func ==(lhs: Event.Errors, rhs: Event.Errors) -> Bool {
    switch (lhs, rhs) {
    case (.eventNotFound, .eventNotFound): return true
    case (.unknown, .unknown): return true
    case (.eventNotFound, _),
         (.unknown, _): return false
    }
}
