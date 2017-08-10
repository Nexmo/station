//
//  LaunchRouter.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 26/10/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit

/// Router for launching application
internal struct LaunchRouter: Router {
    
    /// Launch options from app delegate
    private let options: [UIApplicationLaunchOptionsKey : Any]?
    
    /// Main application window
    private let window: UIWindow?
    
    /// Current user state
    private let isUserLoggedIn: Bool

    // MARK:
    // MARK: Initializers
    
    @discardableResult
    internal init(options: [UIApplicationLaunchOptionsKey : Any]?, window: UIWindow?, isUserLoggedIn: Bool) {
        self.options = options
        self.window = window
        self.isUserLoggedIn = isUserLoggedIn
    }
    
    // MARK:
    // MARK: Setup

    internal func setup() {
        guard isUserLoggedIn else { return }
            
        let navigation = window?.rootViewController as? UINavigationController
        let storyboard = UIStoryboard.storyboard(.main)
        let viewController: ConversationListViewController = storyboard.instantiateViewController()
        
        // display conversation list
        navigation?.setViewControllers([viewController], animated: false)
    }
    
    // MARK:
    // MARK: Protocol - Router

    internal func route<T: RawRepresentable>(to route: T, from source: UIViewController) -> UIViewController? {
        // Not needed since it will be the inital screen
        return nil
    }
}
