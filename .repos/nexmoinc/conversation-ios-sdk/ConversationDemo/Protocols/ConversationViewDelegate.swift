//
//  ConversationViewDelegate.swift
//  ConversationDemo
//
//  Created by James Green on 20/09/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import NexmoConversation

public protocol ConversationViewDelegate {
    func onShowMessageDetail(message: TextEvent)
}
