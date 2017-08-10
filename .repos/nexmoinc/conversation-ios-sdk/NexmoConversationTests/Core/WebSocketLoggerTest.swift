//
//  WebSocketLoggerTest.swift
//  NexmoConversation
//
//  Created by shams ahmed on 01/04/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import UIKit
import Quick
import Nimble
import Mockingjay
import RxSwift
import RxTest
import RxBlocking
@testable import NexmoConversation

internal class WebSocketLoggerTest: QuickSpec {
    
    let logger = WebSocketLogger()
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("doesnt print log") {
            self.logger.log = false
            
            self.logger.error("test", type: "client", args: [])
        }
        
        it("prints socket log") {
            self.logger.log = true
            
            self.logger.log("Adding engine", type: "", args: [])
            self.logger.log("Starting engine. Server: %@", type: "", args: [])
            self.logger.log("Handshaking", type: "", args: [])
            self.logger.log("Sending ws: %@ as type: %@", type: "", args: [])
            self.logger.log("Should parse message: %@", type: "", args: [])
            self.logger.log("Adding handler for event: %@", type: "", args: [])
            self.logger.log("Connect", type: "", args: [])
            self.logger.log("Emitting: %@", type: "", args: [])
            self.logger.log("Writing ws: %@", type: "", args: [])
            self.logger.log("Engine is being closed.", type: "", args: [])
            self.logger.log("Got message: %@", type: "", args: [])
            self.logger.log("Writing ws: %@ has data: %@", type: "", args: [])
            self.logger.log("Parsing %@", type: "", args: [])
            self.logger.log("Decoded packet as: %@", type: "", args: [])
            self.logger.log("Handling event: %@ with data: %@", type: "", args: "disconnect")
            self.logger.log("Handling event: %@ with data: %@", type: "", args: "connect")
            self.logger.log("Handling event: %@ with data: %@", type: "", args: "text:typing:off")
            self.logger.log("Handling event: %@ with data: %@", type: "", args: "text:typing:on")
            self.logger.log("Handling event: %@ with data: %@", type: "", args: "text:delivered")
            self.logger.log("Handling event: %@ with data: %@", type: "", args: "text:seen")
            self.logger.log("session:success", type: "", args: [])
            self.logger.log("Closing socket", type: "", args: [])
            self.logger.log("Disconnected", type: "", args: [])
            self.logger.log("xxx", type: "", args: [])
        }
    }
}
