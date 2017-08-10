//
//  ReachabilityManagerProtocol.swift
//  NexmoConversation
//
//  Created by paul calver on 02/08/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

import Foundation
import RxSwift

internal protocol ReachabilityManagerProtocol {
    
    /// State of network reachability
    var state: Variable<ReachabilityManager.State> { get set }
    
    func updateState(with newState: ReachabilityManager.State)
}

internal extension ReachabilityManagerProtocol {
    
    internal func updateState(with newState: ReachabilityManager.State) {
        state.value = newState
    }
}
