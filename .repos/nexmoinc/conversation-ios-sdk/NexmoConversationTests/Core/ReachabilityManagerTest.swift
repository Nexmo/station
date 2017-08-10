//
//  ReachabilityManagerTest.swift
//  NexmoConversation
//
//  Created by paul calver on 02/08/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
import RxSwift
import RxTest
import RxBlocking
@testable import NexmoConversation

internal class FauxReachabilityManager: ReachabilityManagerProtocol {
    internal var state: Variable<ReachabilityManager.State> = Variable<ReachabilityManager.State>(.failed)
}

internal class ReachabilityManagerTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        
        it("notifies a change of state to not reachable") {
            var newState: ReachabilityManager.State?
            
            let manager = FauxReachabilityManager()
            _ = manager.state.asObservable().skip(1).subscribe(onNext: { state in
                
                newState = state
            })
            
            manager.updateState(with: .notReachable)
            expect(newState).toEventually(equal(.notReachable))
        }
        
        it("notifies a change of state to reachable") {
            var newState: ReachabilityManager.State?
            let manager = FauxReachabilityManager()

            _ = manager.state.asObservable().skip(1).subscribe(onNext: { state in
                newState = state
            })
            
            manager.updateState(with: .reachable(.data))

            expect(newState).toEventually(equal(ReachabilityManager.State.reachable(.data)))
        }
    }
}
