//
//  LazyCollectionTest.swift
//  NexmoConversation
//
//  Created by shams ahmed on 14/07/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import UIKit
import Quick
import Nimble
import Mockingjay
import RxSwift
import RxTest
import RxBlocking
@testable import NexmoConversation

internal class LazyCollectionTest: QuickSpec {
    
    let collection = NexmoConversation.LazyCollection<Int>()
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        
        // MARK:
        // MARK: Test
        
        it("throws for out of bound I value") {
            expect { _ = self.collection[1000] }.to(throwAssertion())
        }
        
        it("throws for out of bound uuid") {
            expect { _ = self.collection[""] }.to(throwAssertion())
        }
        
        it("throws for out of range endIndex") {
            expect { _ = self.collection.index(after: 0) }.to(throwAssertion())
        }
        
        it("returns a nil for safe index") {
            expect(self.collection[safe: 10000]).to(beNil())
        }
    }
}
