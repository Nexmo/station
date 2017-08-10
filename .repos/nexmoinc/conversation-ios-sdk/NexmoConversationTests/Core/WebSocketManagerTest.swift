//
//  WebSocketManagerTest.swift
//  NexmoConversation
//
//  Created by shams ahmed on 22/01/2017.
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

internal class WebSocketManagerTest: QuickSpec {
    
    let socketManager = WebSocketManager(queue: DispatchQueue.global(qos: .background))
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("adds a listener called event") {
            self.socketManager.on("event", { _ in })
        }
        
        it("updates state to connected") {
            self.socketManager.state.value = .connecting
            
            expect(self.socketManager.state.value) == WebSocketManager.State.connecting
        }
        
        it("validates State") {
            let session = Session(id: "1", userId: "usr-123", name: "test user")
            
            expect(WebSocketManager.State.connecting) == WebSocketManager.State.connecting
            expect(WebSocketManager.State.disconnected) == WebSocketManager.State.disconnected
            expect(WebSocketManager.State.connected(session)) == WebSocketManager.State.connected(session)
            expect(WebSocketManager.State.notConnected(.invalidToken)) == WebSocketManager.State.notConnected(.invalidToken)
            expect(WebSocketManager.State.notConnected(.invalidToken)) != WebSocketManager.State.connecting
        }
        
        it("validate State") {
            expect(WebSocketManager.State.Reason.unknown([])) == WebSocketManager.State.Reason.unknown([])
            expect(WebSocketManager.State.Reason.connectionLost) == WebSocketManager.State.Reason.connectionLost
            expect(WebSocketManager.State.Reason.invalidToken) == WebSocketManager.State.Reason.invalidToken
            expect(WebSocketManager.State.Reason.timeout) == WebSocketManager.State.Reason.timeout
            expect(WebSocketManager.State.Reason.timeout) != WebSocketManager.State.Reason.connectionLost
        }
    }
}
