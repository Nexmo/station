//
//  ApplicationRouter.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 26/10/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit

/// Protocol to aid in basic setup
internal protocol Router {
    
    /// setup view controller to present
    ///
    /// - Parameters:
    ///   - route: router
    ///   - source: current view controller
    /// - Returns: new view controller
    @discardableResult
    func route<T: RawRepresentable>(to route: T, from source: UIViewController) -> UIViewController?
}

/// Application routing
///
/// - launch: launch application screen
internal enum ApplicationRouter {
    
    case launch(options: [UIApplicationLaunchOptionsKey : Any]?, window: UIWindow?, isLoggedIn: Bool)
    
    /// Present view controller
    ///
    /// - Returns: view controller it will present next
    @discardableResult
    internal func show() -> UIViewController? {
        switch self {
        case .launch(let options, let window, let isLoggedIn):
            LaunchRouter(options: options, window: window, isUserLoggedIn: isLoggedIn).setup()
            
            // Since we set the inital root view controller, we don't need to present anything yet.
            return nil
        }
    }
}
