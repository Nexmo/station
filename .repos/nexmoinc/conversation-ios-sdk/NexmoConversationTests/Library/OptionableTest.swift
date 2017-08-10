//
//  OptionableTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 25/10/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation

import UIKit
import Quick
import Nimble
import Mockingjay
import RxSwift
@testable import NexmoConversation

internal class OptionableTest: QuickSpec {
    
    let dispose = DisposeBag()
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("unwrap optional values with unwrap") {
            var list: [Int]?
            
            Observable.of(1, 2, 3, nil, Int?(4))
                .unwrap()
                .toArray()
                .subscribe(onNext: { unwrappedValues in
                    list = unwrappedValues
                }, onError: nil, onCompleted: nil, onDisposed: nil)
                .addDisposableTo(self.dispose)
             
            expect(list?.count) == 4
        }
        
        it("unwrap optional values with filter") {
            var list: [Int]?
            
            Observable.of(1, 2, 3, nil, Int?(4))
                .filterNil()
                .toArray()
                .subscribe(onNext: { unwrappedValues in
                    list = unwrappedValues
                }, onError: nil, onCompleted: nil, onDisposed: nil)
                .addDisposableTo(self.dispose)
            
            expect(list?.count) == 4
        }
        
        it("fails to unwrap a nil value") {
            let sum: Bool? = Optional.none
            
            expect { () -> Void in _ = sum.unwrap() }.to(throwAssertion())
        }
    }
}
