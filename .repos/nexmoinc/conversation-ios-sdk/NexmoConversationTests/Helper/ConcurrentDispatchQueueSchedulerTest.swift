//
//  ConcurrentDispatchQueueSchedulerTest.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 28/12/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Mockingjay
import RxSwift
import RxBlocking
@testable import NexmoConversation

internal class ConcurrentDispatchQueueSchedulerTest: QuickSpec {
    
    // MARK:
    // MARK: Test
    
    override func spec() {
        it("does there job in main thread") {
            _ = Observable<Bool>.just(true).subscribeOnMainThread().observeOnMainThread().subscribe()
        }
        
        it("does there job in background thread") {
            _ = Observable<Bool>.just(true).subscribeOnBackground().observeOnBackground().subscribe()
        }
        
        it("does there job in utility thread") {
            _ = Observable<Bool>.just(true).subscribeOn(ConcurrentDispatchQueueScheduler.utility).subscribe()
        }
        
    }
}
