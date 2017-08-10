//
//  AppDelegate.swift
//  ConversationDemo
//
//  Created by James Green on 22/08/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit
import NexmoConversation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    /// Application configuration
    var appConfigurator: AppConfigurator?
    
    /// Nexmo Conversation client
    let client: ConversationClient = {
        // Optional: Set custom configuration like logs, endpoint and other feature flags
        ConversationClient.configuration = Configuration(with: .info)

        return ConversationClient.instance
    }()
    
    // MARK:
    // MARK: Initializers
    
    override init() {
        super.init()
        
        preSetup()
    }
    
    // MARK:
    // MARK: UIApplicationDelegate
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        setup(with: launchOptions)

        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        ApplicationRouter.launch(
            options: launchOptions,
            window: window,
            isLoggedIn: client.account.token != nil
        ).show()

        return true
    }
}
