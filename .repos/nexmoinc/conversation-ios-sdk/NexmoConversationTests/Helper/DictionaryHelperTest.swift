//
//  DictionaryHelperTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 05/01/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
@testable import NexmoConversation

internal class DictionaryHelperTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("merges two dictionary together") {
            var dict1 = [1: 1, 2: 2, 3: 3]
            let dict2 = [4: 4, 5: 5, 6: 6]
            
            dict1 += dict2
            
            expect(dict1.count) == 6
        }
        
        it("merges two dictionary together with second being empty") {
            var dict1 = [1: 1, 2: 2, 3: 3]
            let dict2 = [Int: Int]()
            
            dict1 += dict2
            
            expect(dict1.count) == 3
        }
        
        it("merges two dictionary together with main dictionary empty") {
            var dict1 = [Int: Int]()
            let dict2 = [1: 1, 2: 2, 3: 3]
            
            dict1 += dict2
            
            expect(dict1.count) == 3
        }
    }
}
