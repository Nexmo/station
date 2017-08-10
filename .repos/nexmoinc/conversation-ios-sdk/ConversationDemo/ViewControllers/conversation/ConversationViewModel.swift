//
//  ConversationViewModel.swift
//  NexmoConversation
//
//  Created by shams ahmed on 02/10/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import NexmoConversation

/// ConversationViewController view model
internal struct ConversationViewModel {

    /// Current conversation a view is presenting
    internal var conversation: Conversation? {
        didSet {
            guard let conversation = conversation else { return }
            
            print("\(type(of: self)): \(conversation)")
        }
    }
    
    // MARK:
    // MARK: Send
    
    /// Send text event
    ///
    /// - parameter image: image payload
    internal func send(_ text: String) {
        do {
            try conversation?.send(text)
        } catch {
            print("DEMO: failed to send text event")
        }
    }
    
    /// Send image event
    ///
    /// - parameter image: image payload
    internal func send(_ image: UIImage) {
        do {
            guard let data = UIImageJPEGRepresentation(image, 0.75) else { return }
            
            try conversation?.send(data)
        } catch {
            print("DEMO: failed to send image event")
        }
    }
}
