//
//  DecoderHelperTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 05/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
import Gloss
@testable import NexmoConversation

internal class DecoderHelperTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("returns nil decoding a empty dictionary") {
            let dict = [String: String]()
            guard let formatter = DateFormatter.ISO8601 else { return fail() }
            
            let result = Decoder.decode(dateDictionaryForKey: "", dateFormatter: formatter)(dict)
            
            expect(result).to(beNil())
        }
        
        it("returns a empty list of dates") {
            let dict = [ "dates": [
                "dates1": "XXXX-12-01T17:28:25.933Z",
                "dates2": "XXXX-12-01T17:28:25.933Z"
                ]
            ]
            
            guard let formatter = DateFormatter.ISO8601 else { return fail() }
            
            let result = Decoder.decode(dateDictionaryForKey: "dates", dateFormatter: formatter)(dict)
            
            expect(result?.count) == 0
        }

        it("returns a list of dates") {
            let dict = [ "dates": [
                    "dates1": "2016-12-01T17:28:25.933Z",
                    "dates2": "2017-12-01T17:28:25.933Z"
                ]
            ]
            
            guard let formatter = DateFormatter.ISO8601 else { return fail() }
            
            let result = Decoder.decode(dateDictionaryForKey: "dates", dateFormatter: formatter)(dict)
            
            expect(result?.count) == 2
        }
        
        it("creates a date from a string") {
            let date: Date? = DateFormatter.ISO8601?.date(from: "2017-01-01T09:27:14.875Z")
            
            expect(date).toNot(beNil())
        }
    }
}
