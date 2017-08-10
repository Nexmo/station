//
//  File.swift
//  NexmoChat
//
//  Created by James Green on 25/05/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import NexmoConversation

public protocol MessageComposeDelegate {
    func onTextComposed(_ text: String)
    func onMessageImageComposed(_ image: UIImage)
}
