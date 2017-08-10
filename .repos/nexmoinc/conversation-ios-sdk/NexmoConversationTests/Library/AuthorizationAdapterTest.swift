//
//  AuthorizationAdapterTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 04/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class AuthorizationAdapterTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("returns a adapter") {
            expect(AuthorizationAdapter(with: "token")).toNot(beNil())
        }
        
        it("adds token to a request") {
            guard let url = URL(string: "https://nexmo.com") else { return fail() }
            
            let adapter = AuthorizationAdapter(with: "token")
            let request = try? adapter.adapt(URLRequest(url: url))
            
            expect(request).toNot(beNil())
            expect(request?.allHTTPHeaderFields?[HTTPSessionManager.HeaderKeys.authorization.rawValue]).toNot(beNil())
        }
        
        it("throws for invalid token") {
            guard let url = URL(string: "https://nexmo.com") else { return fail() }

            let adapter = AuthorizationAdapter(with: nil)
            let request = try? adapter.adapt(URLRequest(url: url))
            
            expect(request).to(beNil())
        }
    }
}
