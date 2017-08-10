//
//  UserSelectionDelegate.swift
//  NexmoChat
//
//  Created by James Green on 08/06/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import NexmoConversation

public protocol UserSelectionDelegate: class {
    func onUserSelected(user: String)
}
