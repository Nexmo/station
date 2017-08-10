//
//  TestExample.swift
//  NexmoConversation
//
//  Created by shams ahmed on 24/11/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import UIKit
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class TesExample: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        
        // MARK:
        // MARK: Client
        
        it("Client will not be nil") {
            let client = ConversationClient.instance
            
            expect(client).toNot(beNil())
        }
    }
}
