//
//  SessionAuthenticateTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 27/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class SessionAuthenticateTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("transform to json") {
            let auth = SessionAuthenticate(token: "token")
            
            expect(auth.toJSON()?.count) == 3
        }
    }
}
