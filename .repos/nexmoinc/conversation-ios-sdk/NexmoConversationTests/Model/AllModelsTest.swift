//
//  AllModelsTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 29/11/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class AllModelsTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("tests all edge case for varies data models") {
            expect(PushNotificationCertificate(json: [:])).to(beNil())
        }
    }
}
