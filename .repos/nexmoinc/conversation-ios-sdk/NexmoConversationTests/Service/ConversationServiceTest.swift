//
//  ConversationServiceTest.swift
//  NexmoConversation
//
//  Created by shams ahmed on 03/10/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class ConversationServiceTest: QuickSpec {
    
    let client = NetworkController()
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        
        beforeSuite {
            self.client.token = "token"
        }
        
        // MARK:
        // MARK: Test

        it("fails to fetch user conversation with bad network") {
            self.stubServerError(request: ConversationRouter.all().urlRequest)
            
            var networkError: Error?
            
            self.client.conversationService.all(success: { _ in
                fail()
            }, failure: { error in
                networkError = error
            })
            
            expect(networkError).toEventuallyNot(beNil())
        }
    }
}
