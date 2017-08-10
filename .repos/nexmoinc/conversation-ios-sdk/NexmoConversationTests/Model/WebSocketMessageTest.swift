//
//  WebSocketMessageTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 27/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class WebSocketMessageTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("sends a socket message for successful login") {
            let webSocket = WebSocketManager(queue: .parsering)
            let message = WebSocketMessage([:], forEvent: .sessionLogin, on: webSocket)
            
            message.emit()
            
            expect(message).toNot(beNil())
        }
    }
}
