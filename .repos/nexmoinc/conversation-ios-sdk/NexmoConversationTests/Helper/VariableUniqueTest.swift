//
//  VariableUniqueTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 25/05/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
import RxSwift
@testable import NexmoConversation

internal class VariableUniqueTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("variable can values") {
            let numbers = Variable<Int>(0)
            
            numbers.tryWithValue = 1
            numbers.tryWithValue = 2
            numbers.tryWithValue = 3
            
            expect(numbers.value) == 3
            expect(numbers.tryWithValue) == 3
        }
        
        it("variable can add only unique values") {
            let numbers = Variable<Int>(0)
            
            numbers.tryWithValue = 1
            numbers.tryWithValue = 1
            numbers.tryWithValue = 1
            
            expect(numbers.value) == 1
            expect(numbers.tryWithValue) == 1
        }
    }
}
