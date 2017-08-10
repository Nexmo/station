//
//  EnvironmentTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 09/12/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class EnvironmentTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("creates a new environment") {
            expect(Environment.default).toNot(beNil())
        }
        
        it("checks environment is not in dev mode") {
            expect(Environment.inDEV) == false
        }
        
        it("checks environment fail force test mode") {
            expect(Environment.inFatalErrorTesting) == false
        }
        
        it("pass force test mode") {
            var result = false
            
            Environment.default.forceTesting {
                expect(Environment.inFatalErrorTesting) == true
                result = true
            }
            
            expect(result) == true
        }
    }
}
