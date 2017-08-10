//
//  AppDelegate+Setup.swift
//  NexmoConversation
//
//  Created by Shams Ahmed on 23/12/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit
import NexmoConversation

internal extension AppDelegate {
    
    // MARK:
    // MARK: Setup
    
    /// App Setup
    internal func setup(with launchOptions: [UIApplicationLaunchOptionsKey : Any]?) {
        appConfigurator = AppConfigurator(launchOptions: launchOptions, conversationClient: client)
    }
    
    /// Swizzle
    internal func preSetup() {
        let swizzle: () = { AppConfigurator.swizzleMethods() }()
        swizzle
    }
}
