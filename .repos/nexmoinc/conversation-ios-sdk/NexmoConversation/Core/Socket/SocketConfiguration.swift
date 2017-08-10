//
//  SocketConfiguration.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 26/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import SocketIO

/// Socket IO Configs
internal struct SocketConfiguration {

    // MARK:
    // MARK: Static

    internal static func withLogging(_ isLogEnabled: Bool) -> SocketIOClientConfiguration {
        return [
            .forceWebsockets(true),
            .log(isLogEnabled),
            .path("/rtc/"),
            .logger(WebSocketLogger())
            // TODO: Check for secure connections
        ]
    }
}
