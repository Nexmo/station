//
//  DeviceTokenTest.swift
//  NexmoConversation
//
//  Created by Ivan on 02/02/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import NexmoConversation

class DeviceTokenTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    let client = ConversationClient.instance
    
    override func spec() {
        
        beforeEach {
            
        }
        
        afterEach {
            BasicOperations.logout(client: self.client)
        }
        
        context("register device") {
            it("should pass") {
                BasicOperations.login(with: self.client)

                guard let token = "token".data(using: .utf8) else { return fail() }
                let success = try? self.client.account.update(deviceToken: token, deviceId: "device")
                    .toBlocking()
                    .first()
                
                expect(success).toNot(beNil())
            }
            
            it("should fail when user is not logged in") {
                self.client.addAuthorization(with: "")
                
                guard let token = "token".data(using: .utf8) else { return fail() }
                let success = try? self.client.account.update(deviceToken: token, deviceId: "device")
                    .toBlocking()
                    .first()
                
                expect(success).to(beNil())
            }
            
            it("should fail when device id is empty") {
                BasicOperations.login(with: self.client)

                guard let token = "token".data(using: .utf8) else { return fail() }
                let success = self.client.account.update(deviceToken: token, deviceId: nil)
                
                expect(success).toNot(beNil())
            }
        }
    }
}
