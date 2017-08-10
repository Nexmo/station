//
//  PushTest.swift
//  NexmoConversation
//
//  Created by Ivan on 23/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import XCTest
import Quick
import Nimble
import NexmoConversation

class PushTest: QuickSpec {
    let client = ConversationClient.instance
    
    override func spec() {
        beforeEach {
            
        }
        
        afterEach {
            
        }
        
        // TODO: waiting implementation
        context("enable push") {
            it("should pass") {
                
            }
            
            it("should fail when user is not logged in") {
                
            }
        }
        
        context("disable push") {
            it("should pass") {
                
            }
            
            it("should fail when user is not logged in") {
                
            }
        }
    }
}
