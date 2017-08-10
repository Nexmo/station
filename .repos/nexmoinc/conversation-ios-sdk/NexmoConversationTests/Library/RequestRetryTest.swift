//
//  RequestRetryTest.swift
//  NexmoConversation
//
//  Created by shams ahmed on 19/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import UIKit
import Quick
import Nimble
import Mockingjay
import Alamofire
@testable import NexmoConversation

internal class RequestRetryTest: QuickSpec {
    
    let sessionManager = HTTPSessionManager(queue: .parsering)
    let requestRetry = RequestRetry()
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("stops after 3 retry") {
            // TODO add test case...
        }
        
        it("doesn't do a retry with client error") {
            guard let url = URL(string: "http://httpstat.us/401") else { return fail() }
            
            self.stubServerError(request: URLRequest(url: url), with: 401)
            
            let request = self.sessionManager.request(URLRequest(url: url))
            let error = NSError(domain: "", code: 0)
            var complete = false
            
            request.response(completionHandler: { _ in
                self.requestRetry.should(self.sessionManager, retry: request, with: error, completion: { _ in
                    complete = true
                })
            })
            
            expect(complete).toEventually(beTrue())
        }
        
        it("does a retry with timeout server error") {
            guard let url = URL(string: "http://httpstat.us/408") else { return fail() }
            
            self.stubServerError(request: URLRequest(url: url), with: 408)
            
            let request = self.sessionManager.request(URLRequest(url: url))
            let error = NSError(domain: "", code: 0)
            var complete = false
            
            request.response(completionHandler: { _ in
                self.requestRetry.should(self.sessionManager, retry: request, with: error, completion: { _ in
                    complete = true
                })
            })
            
            expect(complete).toEventually(beTrue())
        }
    }
}
