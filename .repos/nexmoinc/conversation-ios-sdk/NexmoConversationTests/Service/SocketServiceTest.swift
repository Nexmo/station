//
//  SocketServiceTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 25/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class SocketServiceTest: QuickSpec {
    
    let manager = WebSocketManager(queue: .parsering)
    lazy var service: SocketService = SocketService(webSocketManager: self.manager)
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        
        it("receives events from all the listener") {
//            Event.disconnected
//            Event.connect
//            Event.timeout
//            Event.reconnect
//            Event.sessionSuccess
//            Event.sessionInvalid
//            Event.invalidToken
//            Event.expiredToken
//            Event.badPermission
//            Event.error
//            Event.invalidEvent
        }
        
        it("validate session") {
            let json = self.json(path: .sessionSuccess)
            
            expect(self.service.validate([json])) == true
        }
        
        it("fails to validate session") {
            expect(self.service.validate([])) == false
        }
        it("makes a login request") {
            self.service.token = "token"
            
            expect(self.service.login()).toEventually(beTrue())
        }
        
        it("fails to makes a login request") {
            self.service.token = ""
            
            expect(self.service.login()) == false
        }

        it("invalidates session") {
            self.service.updateState(with: .notConnected(.invalidToken))

            expect(self.manager.state.value) == WebSocketManager.State.notConnected(.invalidToken)
        }
    }
}
