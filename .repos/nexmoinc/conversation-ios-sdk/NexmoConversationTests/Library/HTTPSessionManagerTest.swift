//
//  HTTPSessionManagerTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 28/12/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
import Alamofire
@testable import NexmoConversation

internal class HTTPSessionManagerTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("makes a dummy request") {
            guard let url: URL = try? "http://nexmo.com".asURL() else { return fail() }
            
            self.stubServerError(request: URLRequest(url: url))
            
            var didFailRequest = false
            
            let manager = HTTPSessionManager(queue: .parsering)
            manager.adapter = AuthorizationAdapter(with: "token")
            
            manager.request(
                url,
                method: .get,
                parameters: nil,
                encoding: JSONEncoding.default,
                headers: nil)
                .responseJSON(completionHandler: { response in
                    if case .failure(_) = response.result {
                        didFailRequest = true
                    }
                }
            )
            
            expect(didFailRequest).toEventually(beTrue())
        }
    }
}
