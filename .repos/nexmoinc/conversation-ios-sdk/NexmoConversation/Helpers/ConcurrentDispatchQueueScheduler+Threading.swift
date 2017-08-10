//
//  ConcurrentDispatchQueueScheduler+Threading.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 26/10/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - Helper to use on observe/subscribe
internal extension ConcurrentDispatchQueueScheduler {
    
    internal static var utility: ConcurrentDispatchQueueScheduler {
        return ConcurrentDispatchQueueScheduler(qos: .utility)
    }
    
    internal static var background: ConcurrentDispatchQueueScheduler {
        return ConcurrentDispatchQueueScheduler(qos: .background)
    }
}
