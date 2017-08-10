//
//  ConversationListDelegate.swift
//  NexmoChat
//
//  Created by James Green on 27/05/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import NexmoConversation

public protocol ConversationListDelegate {
    func onConversationSelected(conversation: Conversation)
}
