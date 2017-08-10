//
//  KeychainTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 24/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class KeychainTest: QuickSpec {
    
    let keychain = Keychain()
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("sets values in keychain storage") {
            // WARNING: Keychain cannot be tested in framework without a linked app host
        }
        
        it("resets the keychain values") {
            expect(self.keychain.reset()) == false
        }

        it("grabs all values from keychain") {
            expect(self.keychain.allValues()).to(beNil())
        }
    }
}
