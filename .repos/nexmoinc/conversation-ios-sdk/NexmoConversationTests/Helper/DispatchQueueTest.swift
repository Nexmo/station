//
//  DispatchQueueTest.swift
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

internal class DispatchQueueTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("create a new parser") {
            let thread = DispatchQueue.parsering
            
            expect(thread.label) == "com.nexmo.conversation.parsering"
        }

        it("fail to create a parser") {
            Environment.default.forceTesting {
                expect { () -> Void in _ = DispatchQueue.parsering }.to(throwAssertion())
            }
        }
    }
}
