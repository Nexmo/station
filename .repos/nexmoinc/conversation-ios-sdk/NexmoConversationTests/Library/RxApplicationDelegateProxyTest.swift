//
//  RxApplicationDelegateProxyTest.swift
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
import RxCocoa
@testable import NexmoConversation

internal class RxApplicationDelegateProxyTest: QuickSpec {
    
    let dispose = DisposeBag()
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("set proxy delegate") {
            // TODO: find a way to fake UIApplication when in Framework to avoid: 
            // *** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'There can only be one UIApplication instance.'
        }
    }
}
